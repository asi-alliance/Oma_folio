from __future__ import annotations

from typing import Dict, Any, Optional, Tuple

import jax.numpy as jnp

from fabricpc.nodes.base import NodeBase, NodeParams, NodeState, NodeInfo


class NormNode(NodeBase):
    __slots__ = (
        "_norm_type",
        "_num_groups",
        "_eps",
        "_affine",
        "_gamma_init",
        "_beta_init",
    )

    def __init__(
        self,
        name: str,
        norm_type: str = "batch",
        num_groups: int = 32,
        eps: float = 1e-5,
        affine: bool = True,
    ) -> None:
        super().__init__(name)
        self._norm_type = norm_type
        self._num_groups = num_groups
        self._eps = eps
        self._affine = affine
        self._gamma_init = 1.0
        self._beta_init = 0.0

    def init_params(self) -> Dict[str, Any]:
        params: Dict[str, Any] = {}
        if self._affine:
            params["gamma"] = jnp.ones((), dtype=jnp.float32) * self._gamma_init
            params["beta"] = jnp.ones((), dtype=jnp.float32) * self._beta_init
        return params

    def init_state(self) -> NodeState:
        return {}

    def init_state_from_data(self, data: Any = None) -> NodeState:
        return {}

    def init_node_info(self) -> NodeInfo:
        return {"mass_tau": 1.0}

    def _normalize(self, x: jnp.ndarray, params: NodeParams, eps: Optional[float] = None) -> jnp.ndarray:
        if eps is None:
            eps = self._eps
        gamma = params.get("gamma", 1.0)
        beta = params.get("beta", 0.0)

        if self._norm_type == "batch":
            mean = jnp.mean(x, axis=0, keepdims=True)
            var = jnp.mean((x - mean) ** 2, axis=0, keepdims=True)
            x_norm = (x - mean) / jnp.sqrt(var + eps)

        elif self._norm_type == "layer":
            mean = jnp.mean(x, axis=-1, keepdims=True)
            var = jnp.mean((x - mean) ** 2, axis=-1, keepdims=True)
            x_norm = (x - mean) / jnp.sqrt(var + eps)

        elif self._norm_type == "group":
            groups = self._num_groups
            shape = x.shape
            if len(shape) == 4:
                N, C, H, W = shape
                x_reshaped = x.reshape(N, groups, C // groups, H, W)
                mean = jnp.mean(x_reshaped, axis=(2, 3, 4), keepdims=True)
                var = jnp.mean((x_reshaped - mean) ** 2, axis=(2, 3, 4), keepdims=True)
                x_norm = (x_reshaped - mean) / jnp.sqrt(var + eps)
                x_norm = x_norm.reshape(N, C, H, W)
            else:
                x_reshaped = x.reshape(groups, -1)
                mean = jnp.mean(x_reshaped, axis=-1, keepdims=True)
                var = jnp.mean((x_reshaped - mean) ** 2, axis=-1, keepdims=True)
                x_norm = (x_reshaped - mean) / jnp.sqrt(var + eps)
                x_norm = x_norm.reshape(shape)

        elif self._norm_type == "instance":
            shape = x.shape
            if len(shape) == 4:
                N, C, H, W = shape
                x_reshaped = x.reshape(N * C, 1, H, W)
                mean = jnp.mean(x_reshaped, axis=(2, 3), keepdims=True)
                var = jnp.mean((x_reshaped - mean) ** 2, axis=(2, 3), keepdims=True)
                x_norm = (x_reshaped - mean) / jnp.sqrt(var + eps)
                x_norm = x_norm.reshape(N, C, H, W)
            else:
                mean = jnp.mean(x, axis=-1, keepdims=True)
                var = jnp.mean((x - mean) ** 2, axis=-1, keepdims=True)
                x_norm = (x - mean) / jnp.sqrt(var + eps)

        else:
            raise ValueError(f"Unknown norm_type: {self._norm_type}")

        return gamma * x_norm + beta

    def predict(
        self,
        params: NodeParams,
        inputs: Dict[str, jnp.ndarray],
        state: NodeState,
        node_info: NodeInfo,
    ) -> Tuple[jnp.ndarray, Optional[Dict[str, Any]]]:
        z_mu = None
        for edge_key, x in inputs.items():
            if z_mu is None:
                z_mu = x
            else:
                z_mu = z_mu + x
        z_mu = self._normalize(z_mu, params)
        return z_mu, None

    def serialize(self) -> Dict[str, Any]:
        return {
            "name": self._name,
            "type": self.__class__.__name__,
            "norm_type": self._norm_type,
            "num_groups": self._num_groups,
            "eps": self._eps,
            "affine": self._affine,
        }
