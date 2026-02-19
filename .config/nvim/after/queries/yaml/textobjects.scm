; extends

; YAML block list item: "- alert: ..." (this is what your Prometheus rules use)
(block_sequence_item) @yaml_item.outer
(block_mapping_pair)  @yaml_block.outer

(block_sequence_item (block_node) @yaml_item.inner)
(block_sequence_item (flow_node)  @yaml_item.inner)
