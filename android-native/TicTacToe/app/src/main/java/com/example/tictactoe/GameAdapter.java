package com.example.tictactoe;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;

import androidx.annotation.NonNull;

import java.util.List;

public class GameAdapter extends ArrayAdapter<CellState> {

    private final List<CellState> objects;
    private final int layout;
    private final LayoutInflater inflater;
    private final int cellLength;
    public GameAdapter(@NonNull Context context, int resource, @NonNull List<CellState> objects, int cellLength) {
        super(context, resource, objects);
        this.objects = objects;
        this.layout = resource;
        this.inflater = LayoutInflater.from(context);
        this.cellLength = cellLength;
    }
    @NonNull
    @Override
    public View getView(int position, View convertView, @NonNull ViewGroup parent)
    {
        View view = inflater.inflate(this.layout, parent, false);
        ImageView cell = view.findViewById(R.id.cell_game_table);
        ViewGroup.LayoutParams lp = cell.getLayoutParams();
        lp.height = cellLength;
        lp.width = cellLength;
        cell.setLayoutParams(lp);
        if(objects.get(position) != CellState.Empty) {
            cell.setImageResource(objects.get(position) ==  CellState.Cross ? R.drawable.cross : R.drawable.circle);
        }
        return view;
    }
}
