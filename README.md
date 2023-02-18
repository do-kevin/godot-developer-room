# godot-developer-room

3.5.1(Stable)

## Development

### Updating imported 3D assets

.tscn and/or scripts breaking due to re-importing a new updated 3d asset?
Select the .tscn, for example the player.glb, check the import tab. Tick off Keep On Reimport off and press "Reimport".

Drag the new .glb into the same directory of the old one. Open Inherit New Scene with the new .glb. Now, copy the AnimationPlayer of the new .glb and paste it into the Player.tscn.

If the AnimationTree is there in your scene file, Player.tscn, you have to re-assign it to the new AnimationPlayer. Now check the new animations are affecting the mesh.