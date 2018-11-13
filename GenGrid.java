package main;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

import game.SaveWesteros;
import game.SaveWesterosNode;

public class GenGrid
{
	public static final int EMPTY = 0;
	public static final int DRAGONSTONE = 1;
	public static final int WHITEWALKER = 2;
	public static final int OBSTACLE = 3;

	public static void printStatements(int rows, int cols) throws IOException
	{
		// Initialise grid-world map
		int[][] grid = new int[rows][cols];
		// Generate a number of whitewalkers and obstacles to some random number in between 1 and the
		// longest dimension of the grid-world
		int numWhiteWalkers = (int) (1 + Math.random() * (Math.max(rows, cols)));
		int numObstacles =  (int) (1 + Math.random() * (Math.max(rows, cols)));
		// Generate the number of maximum dragonglass carrying capacity to some random number in
		// between 1 and half the number of white walkers generated (minimum 1)
		int numDragonglassPieces = (int) (1 + Math.random() * (double)numWhiteWalkers / 1.5);

		// Make sure all cells of the grid-world are empty at first
		for (int i = 0; i < grid.length; i++)
		{
			for (int j = 0; j < grid[i].length; j++) 
			{
				grid[i][j] = EMPTY;
			}
		}

		// Add all the obstacles to the grid-world to random locations
		int k = 0;
		while (k < numObstacles)
		{
			int newC = (int) (Math.random() * grid[0].length);
			int newR = (int) (Math.random() * grid.length);
			if (!(newC == grid[0].length - 1 && newR == grid.length - 1) && grid[newR][newC] == EMPTY)
			{
				grid[newR][newC] = OBSTACLE;
				k++;
			}
		}

		// Add all the whitewalkers to the grid-world to random locations
		k = 0;
		while (k < numWhiteWalkers)
		{
			int newC = (int) (Math.random() * grid[0].length);
			int newR = (int) (Math.random() * grid.length);
			if (!(newC == grid[0].length - 1 && newR == grid.length - 1) && grid[newR][newC] == EMPTY)
			{
				grid[newR][newC] = WHITEWALKER;
				k++;
			}
		}

		// Keep looking for a random location to add the dragonstone until one is found
		boolean noStone = true;
		do
		{
			int newC = (int) (Math.random() * grid[0].length);
			int newR = (int) (Math.random() * grid.length);
			if (!(newC == grid[0].length - 1 && newR == grid.length - 1) && grid[newR][newC] == EMPTY)
			{
				grid[newR][newC] = DRAGONSTONE;
				noStone = false;
			}
		} while (noStone);

		String preds = "";
		preds += "rows(" + rows + ").\n";
		preds += "cols(" + cols + ").\n";
		preds += "dragonglass(" + numDragonglassPieces + ").\n";
		for(int row = 0 ; row < rows ; row++)
		{
			for(int col = 0 ; col < cols ; col++)
			{
				preds += (grid[row][col] == SaveWesteros.EMPTY) ? "empty(" + row + ", " + col + ", _)." 
						: (grid[row][col] == SaveWesteros.DRAGONSTONE) ? "dragonstone(" + row + ", " + col + ")."
								: (grid[row][col] == SaveWesteros.WHITEWALKER) ? "whitewalker(" + row + ", " + col + ", s0)."
										: "obstacle(" + row + ", " + col + ").";
				preds += "\n";
			}
		}
		preds += "jon(" + (rows - 1) + ", " + (cols - 1) +  ", " + 0 + ", s0).\n";
		preds += "\n=====\n\n";

		Files.write(Paths.get("grids.txt"), preds.getBytes(), StandardOpenOption.APPEND);
	}

	public static void main(String[] args) throws IOException
	{
		for(int i = 0; i < 10 ; i++)
		{
			printStatements(3, 3);
		}
	}
}
