from __future__ import annotations
import os, json, hashlib, base64
from pathlib import Path
from typing import Any, Dict, Optional
import numpy as np
import jax.numpy as jnp
from fabricpc.core.types import (GraphParams, NodeParams, GraphState, NodeState, GraphStructure, NodeInfo, EdgeInfo, SlotInfo)
MAGIC = b'FBPC1'
VERSION = 1
def _array_to_dict(arr):
    arr = np.asarray(arr)
    return {'dtype': str(arr.dtype), 'shape': list(arr.shape), 'data': base64.b64encode(arr.tobytes()).decode('ascii')}
def _dict_to_array(d):
    arr = np.frombuffer(base64.b64decode(d['data']), dtype=np.dtype(d['dtype']))
    return jnp.asarray(arr.reshape(d['shape']))
def _serialize_node_params(np_params):
    return {'weights': {k: _array_to_dict(v) for k, v in np_params.weights.items()}, 'biases': {k: _array_to_dict(v) for k, v in np_params.biases.items()}}
def _serialize_graph_params(params):
    return {'nodes': {k: _serialize_node_params(v) for k, v in params.nodes.items()}}
def _deserialize_node_params(data):
    return NodeParams(weights={k: _dict_to_array(v) for k, v in data['weights'].items()}, biases={k: _dict_to_array(v) for k, v in data['biases'].items()})
def _deserialize_graph_params(data):
    return GraphParams(nodes={k: _deserialize_node_params(v) for k, v in data['nodes'].items()})
def _serialize_node_state(ns):
    return {'z_latent': _array_to_dict(ns.z_latent), 'z_mu': _array_to_dict(ns.z_mu), 'error': _array_to_dict(ns.error), 'energy': _array_to_dict(ns.energy), 'latent_grad': _array_to_dict(ns.latent_grad)}
def _serialize_graph_state(state):
    return {'nodes': {k: _serialize_node_state(v) for k, v in state.nodes.items()}, 'batch_size': state.batch_size}
def _deserialize_node_state(data):
    return NodeState(z_latent=_dict_to_array(data['z_latent']), z_mu=_dict_to_array(data['z_mu']), error=_dict_to_array(data['error']), energy=_dict_to_array(data['energy']), latent_grad=_dict_to_array(data['latent_grad']))
def _deserialize_graph_state(data):
    return GraphState(nodes={k: _deserialize_node_state(v) for k, v in data['nodes'].items()}, batch_size=data['batch_size'])
def _serialize_structure(structure):
    def _ser(o):
        if isinstance(o, (NodeInfo, EdgeInfo, SlotInfo)):
            return {k: _ser(v) for k, v in o._asdict().items()}
        if isinstance(o, dict):
            return {k: _ser(v) for k, v in o.items()}
        if isinstance(o, (list, tuple)):
            return [_ser(x) for x in o]
        if isinstance(o, (np.ndarray, jnp.ndarray)):
            return _array_to_dict(o)
        return o
    return _ser(structure._asdict()) if hasattr(structure, '_asdict') else _ser(structure)
def _deserialize_structure(data):
    return data
def _pytree_to_serial(obj):
    if isinstance(obj, (np.ndarray, jnp.ndarray)):
        return {'__array__': True, **_array_to_dict(obj)}
    if isinstance(obj, dict):
        return {k: _pytree_to_serial(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return {'__list__': True, 'items': [_pytree_to_serial(x) for x in obj]}
    if isinstance(obj, (int, float, bool, str, type(None))):
        return obj
    if hasattr(obj, '__dict__'):
        return {'__obj__': True, 'type': type(obj).__name__, 'attrs': {k: _pytree_to_serial(v) for k, v in obj.__dict__.items()}}
    return str(obj)
def _serial_to_pytree(data):
    if isinstance(data, dict):
        if data.get('__array__'):
            return _dict_to_array(data)
        if data.get('__list__'):
            return [_serial_to_pytree(x) for x in data['items']]
        if data.get('__obj__'):
            return {k: _serial_to_pytree(v) for k, v in data.get('attrs', {}).items()}
        return {k: _serial_to_pytree(v) for k, v in data.items()}
    if isinstance(data, list):
        return [_serial_to_pytree(x) for x in data]
    return data
def _write_atomic(ckpt_dir, filename, data):
    tmp_path = ckpt_dir / (filename + '.tmp')
    final_path = ckpt_dir / filename
    with open(tmp_path, 'wb') as f:
        f.write(data)
    os.replace(str(tmp_path), str(final_path))
    return hashlib.sha256(data).hexdigest()
def _cleanup_tmp(ckpt_dir):
    for f in ckpt_dir.iterdir():
        if f.suffix == '.tmp':
            f.unlink(missing_ok=True)
def save_checkpoint(path, params, structure=None, opt_state=None, state=None, extra_metadata=None):
    ckpt_dir = Path(path)
    ckpt_dir.mkdir(parents=True, exist_ok=True)
    checksums = {}
    params_data = _serialize_graph_params(params)
    try:
        import msgpack
        params_bytes = msgpack.packb(params_data, use_bin_type=True)
    except ImportError:
        params_bytes = json.dumps(params_data, default=str).encode()
    checksums['params.bin'] = _write_atomic(ckpt_dir, 'params.bin', params_bytes)
    if structure is not None:
        try:
            struct_data = _serialize_structure(structure)
            struct_bytes = json.dumps(struct_data, indent=2, default=str).encode('utf-8')
            checksums['structure.json'] = _write_atomic(ckpt_dir, 'structure.json', struct_bytes)
        except Exception:
            pass
    if opt_state is not None:
        opt_data = _pytree_to_serial(opt_state)
        try:
            import msgpack
            opt_bytes = msgpack.packb(opt_data, use_bin_type=True)
        except ImportError:
            opt_bytes = json.dumps(opt_data, default=str).encode()
        checksums['opt_state.bin'] = _write_atomic(ckpt_dir, 'opt_state.bin', opt_bytes)
    if state is not None:
        state_data = _serialize_graph_state(state)
        try:
            import msgpack
            state_bytes = msgpack.packb(state_data, use_bin_type=True)
        except ImportError:
            state_bytes = json.dumps(state_data, default=str).encode()
        checksums['state.bin'] = _write_atomic(ckpt_dir, 'state.bin', state_bytes)
    metadata = {'magic': MAGIC.decode('ascii'), 'version': VERSION, 'files': list(checksums.keys()), 'checksums': checksums, 'extra': extra_metadata or {}}
    meta_bytes = json.dumps(metadata, indent=2).encode('utf-8')
    _write_atomic(ckpt_dir, 'metadata.json', meta_bytes)
    _cleanup_tmp(ckpt_dir)
    return str(ckpt_dir)
def load_checkpoint(path, load_structure=True, load_opt_state=True, load_state=True):
    ckpt_dir = Path(path)
    meta_path = ckpt_dir / 'metadata.json'
    if not meta_path.exists():
        raise FileNotFoundError(f'Checkpoint metadata not found: {meta_path}')
    with open(meta_path, 'r') as f:
        metadata = json.load(f)
    if metadata.get('magic') != MAGIC.decode('ascii'):
        raise ValueError('Invalid checkpoint format')
    result = {'params': None, 'structure': None, 'opt_state': None, 'state': None, 'metadata': metadata}
    params_path = ckpt_dir / 'params.bin'
    if params_path.exists():
        raw = open(params_path, 'rb').read()
        try:
            import msgpack
            data = msgpack.unpackb(raw, raw=False)
        except ImportError:
            data = json.loads(raw.decode())
        result['params'] = _deserialize_graph_params(data)
    if load_structure:
        struct_path = ckpt_dir / 'structure.json'
        if struct_path.exists():
            with open(struct_path, 'r') as f:
                result['structure'] = _deserialize_structure(json.load(f))
    if load_opt_state:
        opt_path = ckpt_dir / 'opt_state.bin'
        if opt_path.exists():
            raw = open(opt_path, 'rb').read()
            try:
                import msgpack
                data = msgpack.unpackb(raw, raw=False)
            except ImportError:
                data = json.loads(raw.decode())
            result['opt_state'] = _serial_to_pytree(data)
    if load_state:
        state_path = ckpt_dir / 'state.bin'
        if state_path.exists():
            raw = open(state_path, 'rb').read()
            try:
                import msgpack
                data = msgpack.unpackb(raw, raw=False)
            except ImportError:
                data = json.loads(raw.decode())
            result['state'] = _deserialize_graph_state(data)
    return result
