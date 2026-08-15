(|- ((--> original_research toric_rlct_resolution) ConstructiveRLCTforReLUNetworks) (stv 0.9 0.95))
(|- ((==> (--> SingleHiddenLayerReLU NeuralNetworkParameterSpace) (--> ParameterSpace ToricVariety)) (stv 0.95 0.95)))
(|- ((==> (--> ParameterSpace ToricVariety) (--> ConstructiveLogResolution PossibleViaFanRefinement)) (stv 0.9 0.9)))
(|- ((==> (--> ConstructiveLogResolution PossibleViaFanRefinement) (--> RLCT Computable)) (stv 0.85 0.9)))