from __future__ import annotations
from typing import Dict, Any, Optional, Tuple, TYPE_CHECKING
import jax
import jax.numpy as jnp
from fabricpc.nodes.base import NodeBase, SlotSpec
from fabricpc.core.types import NodeParams, NodeState, NodeInfo
from fabricpc.core.activations import IdentityActivation
from fabricpc.core.energy import GaussianEnergy
from fabricpc.core.initializers import NormalInitializer

if TYPE_CHECKING:
    from fabricpc.core.activations import ActivationBase
    from fabricpc.core.energy import EnergyFunctional
    from fabricpc.core.initializers import InitializerBase


class NormNode(NodeBase):
    # Normalization node: BatchNorm/LayerNorm/GroupNorm + affine transform

    def __init__(self, shape, name, norm_type="layer", activation=None, energy=None, latent_init=None, eps=1e-5, num_groups=32, momentum=0.9):
        if activation is None:
            activation = IdentityActivation()
        if energy is None:
            energy = GaussianEnergy()
        if latent_init is None:
            latent_init = NormalInitializer()
        super().__init__(shape=shape, name=name, activation=activation, energy=energy, latent_init=latent_init)
        self._norm_type = norm_type
        self._eps = eps
        self._num_groups = num_groups
        self._momentum = momentum

    @property
    def norm_type(self):
        return self._norm_type

    @staticmethod
    def get_slots():
        return {"in": SlotSpec(name="in", is_multi_input=True)}

    @staticmethod
    def get_variance_factor(source_shape, config, weight_init=None):
        return 1.0

    @staticmethod
    def initialize_params(key, node_shape, input_shapes, weight_init=None, config=None):
        if config is None:
            config = {}
        norm_type = config.get("norm_type", "layer")
        if len(node_shape) == 1:
            param_shape = node_shape
        else:
            param_shape = (node_shape[0],) + (1,) * (len(node_shape) - 1)
        gamma = jnp.ones(param_shape)
        beta =