package com.example.tictactoe;

import java.util.ArrayList;
import java.util.List;

enum CellState {
    Empty,
    Cross,
    Circle,
    Draw
}
class Point<T>
{
    public T x;
    public T y;
    public Point()
    {}
    public Point(T x, T y)
    {
        this.x = x;
        this.y = y;
    }

}
class Line<T>
{
    public Point<T> p1;
    public Point<T> p2;
    public Line()
    {}
    public Line(Point<T> p1, Point<T> p2)
    {
        this.p1 = p1;
        this.p2 = p2;
    }
    public static Point<Integer> getIntersection(Line<Integer> l1, Line<Integer> l2)
    {
        int a1 = l1.p2.y - l1.p1.y;
        int b1 = l1.p2.x - l1.p1.x;
        int c1 = l1.p1.x * l1.p2.y - l1.p1.y * l1.p2.x;
        int a2 = l2.p2.y - l2.p1.y;
        int b2 = l2.p2.x - l2.p1.x;
        int c2 = l2.p1.x * l2.p2.y - l2.p1.y * l2.p2.x;
        int den = b1 * a2 - b2 * a1;
        if(den == 0)
            return null;
        return new Point<Integer>((b1 * c2 - b2 * c1) / den, (a1 * c2 - a2 * c1) / den);
    }

}
public class GameLogic {

    private ArrayList<ArrayList<CellState>> gameTable;
    private final int gameSize;
    private final int cellCountForWin;

    private boolean InProcess;
    private CellState step;
    private int count = 0;

    public GameLogic(int gameSize, int cellCountForWin, CellState initStep) {
        this.gameSize = gameSize;
        this.cellCountForWin = cellCountForWin;
        this.step = initStep;
        gameTable = new ArrayList<>(gameSize);
        for(int i = 0; i < gameSize; i++) {
            gameTable.add( new ArrayList<>(gameSize));
            for(int j = 0; j < gameSize; j++) {
                gameTable.get(i).add(CellState.Empty);
            }
        }
        this.InProcess = true;
        Point<Integer> test = Line.getIntersection(new Line<>(new Point<>(3,0), new Point<>(3, 1)), new Line<>(new Point<>(3,0), new Point<>(3, 1)));
    }
    public CellState getWinner()
    {
        if(InProcess)
            return CellState.Empty;
        return step;
    }
    public CellState getCurrentStep()
    {
        return step;
    }
    public ArrayList<CellState> getState()
    {
        ArrayList<CellState> res = new ArrayList<>(gameSize * gameSize);

        for(int x = 0; x < gameSize; x++)
            for(int y = 0; y < gameSize; y++)
                res.add(gameTable.get(x).get(y));
        return res;
    }
    public boolean step(int posx, int posy)
    {
        if(InProcess && gameTable.get(posx).get(posy) == CellState.Empty)
        {
            gameTable.get(posx).set(posy, step);
            count++;
            if(getMaxUnbroken(posx, posy) >= cellCountForWin)
                InProcess = false;
            else if(count == gameSize*gameSize)
            {
                step = CellState.Draw;
                InProcess = false;
            }
            else {
                step = step == CellState.Circle ? CellState.Cross : CellState.Circle;
            }
            return true;
        }
        return false;
    }

    private int getMaxUnbroken(int posx, int posy)
    {
        int maxUnbroken = 0;

        // hor
        int curUnbroken = 0;
        for(int i = 0; i < gameSize; i++)
            if(step == gameTable.get(i).get(posy))
                curUnbroken++;
            else {
                maxUnbroken = Math.max(maxUnbroken, curUnbroken);
                curUnbroken = 0;
            }
        maxUnbroken = Math.max(maxUnbroken, curUnbroken);

        // vert
        curUnbroken = 0;
        for(int i = 0; i < gameSize; i++)
            if(step == gameTable.get(posx).get(i))
                curUnbroken++;
            else {
                maxUnbroken = Math.max(maxUnbroken, curUnbroken);
                curUnbroken = 0;
            }
        maxUnbroken = Math.max(maxUnbroken, curUnbroken);

        Line<Integer> left = new Line<Integer>(new Point<Integer>(0,0), new Point<Integer>(gameSize - 1, 0));
        Line<Integer> top = new Line<Integer>(new Point<Integer>(0,0), new Point<Integer>(0, gameSize - 1));
        Line<Integer> bottom = new Line<Integer>(new Point<Integer>(gameSize - 1, 0), new Point<Integer>(gameSize - 1,gameSize - 1));
        Line<Integer> right = new Line<Integer>(new Point<Integer>(0, gameSize - 1), new Point<Integer>(gameSize - 1, gameSize - 1));

        Line<Integer> axis1 = new Line<Integer>(new Point<Integer>(posx, posy), new Point<Integer>(posx + 1, posy + 1));
        Line<Integer> axis2 = new Line<Integer>(new Point<Integer>(posx, posy), new Point<Integer>(posx + 1, posy - 1));


        // main diagonal
        Point<Integer> intersection = filter(Line.getIntersection(axis1, left));
        intersection = intersection != null ? intersection : filter(Line.getIntersection(axis1, top));
        curUnbroken = 0;
        if(intersection != null)
        {
            for(int x = intersection.x, y = intersection.y; x < gameSize && y < gameSize; x++, y++)
                if(step == gameTable.get(x).get(y))
                    curUnbroken++;
                else {
                    maxUnbroken = Math.max(maxUnbroken, curUnbroken);
                    curUnbroken = 0;
                }
        }
        else
        {
            intersection = filter(Line.getIntersection(axis1, right));
            intersection = intersection != null ? intersection : filter(Line.getIntersection(axis1, bottom));

            if(intersection == null)
                throw new RuntimeException();
            for(int x = intersection.x, y = intersection.y; x >= 0 && y >= 0; x--, y--)
                if(step == gameTable.get(x).get(y))
                    curUnbroken++;
                else {
                    maxUnbroken = Math.max(maxUnbroken, curUnbroken);
                    curUnbroken = 0;
                }
        }
        maxUnbroken = Math.max(maxUnbroken, curUnbroken);

        // side diagonal
        intersection = filter(Line.getIntersection(axis2, left));
        intersection = intersection != null ? intersection : filter(Line.getIntersection(axis2, bottom));
        curUnbroken = 0;
        if(intersection != null)
        {
            for(int x = intersection.x, y = intersection.y; x >= 0 && y < gameSize; x--, y++)
                if(step == gameTable.get(x).get(y))
                    curUnbroken++;
                else {
                    maxUnbroken = Math.max(maxUnbroken, curUnbroken);
                    curUnbroken = 0;
                }
        }
        else
        {
            intersection = filter(Line.getIntersection(axis2, right));
            intersection = intersection != null ? intersection : filter(Line.getIntersection(axis2, top));

            if(intersection == null)
                throw new RuntimeException();
            for(int x = intersection.x, y = intersection.y; x < gameSize && y >= 0; x++, y--)
                if(step == gameTable.get(x).get(y))
                    curUnbroken++;
                else {
                    maxUnbroken = Math.max(maxUnbroken, curUnbroken);
                    curUnbroken = 0;
                }
        }
        maxUnbroken = Math.max(maxUnbroken, curUnbroken);

        return maxUnbroken;
    }

    private Point<Integer> filter(Point<Integer> p)
    {
        if(p == null)
            return null;
        if(0 <= p.x && p.x < gameSize && 0 <= p.y && p.y < gameSize)
            return p;
        return null;
    }
}
