using Godot;
using System;

public partial class PuzzlePushBlock : Node2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public override void _PhysicsProcess(double delta)
	{

	}

	public int Push() {
		this.Position += new Vector2(0, 32);
		return 0;
	}
}
