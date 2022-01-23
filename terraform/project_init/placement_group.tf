resource "hcloud_placement_group" "group_spread" {
  name = "group_spread"
  type = "spread"
}