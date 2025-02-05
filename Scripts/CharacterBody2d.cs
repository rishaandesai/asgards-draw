using Godot;
using System;

public partial class CharacterBody2d : CharacterBody2D
{
	public const float Speed = 500.0f;

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		if (direction != Vector2.Zero)
		{
			velocity.X = direction.X * Speed;
			velocity.Y = direction.Y * Speed;
			//check for collisin with a push block (collision lauer 2)
			for (int i = 0; i < GetSlideCollisionCount(); i++)
			{
				KinematicCollision2D collision = GetSlideCollision(i);
				if (collision.GetCollider().GetType() == typeof(PuzzlePushBlock))
				{
					PuzzlePushBlock pushBlock = (PuzzlePushBlock)collision.GetCollider();
					
				}
			}
			// Normalize velocity if moving diagonally.
			velocity = velocity.Normalized() * Speed;
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Y = Mathf.MoveToward(Velocity.Y, 0, Speed);
		}

		Velocity = velocity;
		MoveAndSlide();
	}
}
