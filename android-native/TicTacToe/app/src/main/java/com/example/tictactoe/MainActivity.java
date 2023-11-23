package com.example.tictactoe;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.NumberPicker;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
public class MainActivity extends AppCompatActivity {

    private TextView messageView;
    private GameLogic gameLogic;
    public int gameSize = 3;
    public int cellCountForWin = 3;
    public final int gameSizeMin = 3;
    public final int gameSizeMax = 6;
    private final CellState firstStep = CellState.Cross;
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        messageView = findViewById(R.id.message_box);

        initControls();
        reInitGame();
    }
    private void initControls()
    {
        NumberPicker gameDimensionPicker = findViewById(R.id.gameDimensionPicker);
        NumberPicker sequenceSizePicker = findViewById(R.id.sequenceSizeForWinPicker);
        Button restartButton = findViewById(R.id.restartBut);

        gameDimensionPicker.setMinValue(gameSizeMin);
        gameDimensionPicker.setMaxValue(gameSizeMax);
        gameDimensionPicker.setValue(gameSize);
        gameDimensionPicker.setOnValueChangedListener((numberPicker, oldVal, newVal) -> gameSize = oldVal);
        sequenceSizePicker.setMinValue(gameSizeMin);
        sequenceSizePicker.setMaxValue(gameSizeMax);
        sequenceSizePicker.setValue(cellCountForWin);
        sequenceSizePicker.setOnValueChangedListener((numberPicker, oldVal, newVal) -> cellCountForWin = oldVal);

        restartButton.setOnClickListener(view -> reInitGame());
    }

    private void reInitGame()
    {
        int cellSize = 900 / gameSize;
        gameLogic = new GameLogic(gameSize,cellCountForWin,firstStep);
        GridView gameTableView = findViewById(R.id.game_table);
        gameTableView.setNumColumns(gameSize);
        setMessage(firstStep == CellState.Cross ? R.string.playerX_step : R.string.playerO_step);
        GameAdapter adapter = new GameAdapter(this, R.layout.cell, gameLogic.getState(), cellSize);
        gameTableView.setAdapter(adapter);
        gameTableView.setOnItemClickListener((adapterView, view, i, l) -> {
            int x = i / gameSize;
            int y = i % gameSize;
            CellState prevStep = MainActivity.this.gameLogic.getCurrentStep();
            ImageView cell = view.findViewById(R.id.cell_game_table);
            if(MainActivity.this.gameLogic.step(x, y))
            {
                CellState winner = MainActivity.this.gameLogic.getWinner();
                cell.setImageResource(prevStep == CellState.Circle ? R.drawable.circle : R.drawable.cross);
                switch (winner)
                {
                    case Cross:
                    {
                        MainActivity.this.messageView.setText(R.string.playerX_won);
                        Toast.makeText(MainActivity.this, R.string.playerX_won, Toast.LENGTH_LONG).show();

                    }break;
                    case Circle:
                    {
                        MainActivity.this.messageView.setText(R.string.playerO_won);
                        Toast.makeText(MainActivity.this, R.string.playerO_won, Toast.LENGTH_LONG).show();
                    }break;
                    case Empty:
                        setMessage(prevStep == CellState.Cross ? R.string.playerO_step : R.string.playerX_step);
                    break;
                    case Draw:
                    {
                        MainActivity.this.messageView.setText(R.string.draw);
                        Toast.makeText(MainActivity.this, R.string.draw, Toast.LENGTH_LONG).show();
                    }
                }

            }
        });
        Toast.makeText(MainActivity.this, R.string.newGame, Toast.LENGTH_SHORT).show();
    }

    public void setMessage(int message)
    {
        messageView.setText(message);
    }



}
