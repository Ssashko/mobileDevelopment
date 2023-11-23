import 'dart:math';

enum SwipeSide {
  left,
  bottom,
  right,
  top
}

class GameLogic2048 {
  late int gameSize;
  final int _initialCellCount;
  late List<List<int>> _gameState;
  late int score;
  bool hasChanged = false;
  GameLogic2048(int sz, int initialCellCount) :
    _initialCellCount = initialCellCount
  {
    clear(sz);
  }
  void clear(int sz) {
    gameSize = sz;
    _gameState = List<List<int>>.generate(gameSize, (i) => List<int>.generate(
        gameSize, (i) => 0
    ));
    for(int i = 0; i < _initialCellCount; i++) {
      _insertCell(true);
    }
    score = 0;
  }

  List<List<int>> get state => _gameState;
  int get size => gameSize;
  List<List<int>> get stateCopy => List<List<int>>.generate(
      gameSize, (i) => List<int>.generate(gameSize, (j) => _gameState[i][j]));

  bool step(SwipeSide side)
  {
    var oldGame = stateCopy;
    switch(side)
    {
      case SwipeSide.top:
        _shiftTop();
        break;
      case SwipeSide.left:
        _shiftLeft();
        break;
      case SwipeSide.bottom:
        _shiftBottom();
        break;
      case SwipeSide.right:
        _shiftRight();
    }
    hasChanged = _hasChanged(oldGame);
    if(hasChanged)
      {
        _insertCell();
      }
    return hasChanged;
  }
  void _addPoint(int i)
  {
    if(i > 0) {
      score += pow(2, i) as int;
    }
  }
  void _insertCell([bool? requiredAdd]) {
    List<(int, int)> cells = [];
    for (int i = 0; i < gameSize; i++) {
      for (int j = 0; j < gameSize; j++) {
        if (_gameState[i][j] == 0) {
          cells.add((i, j));
        }
      }
    }
    if (cells.isNotEmpty) {
      final random = Random();
      var (x, y) = cells[random.nextInt(cells.length)];
      var max = requiredAdd == null || !requiredAdd ? 7 : 6;
      switch (random.nextInt(max)) {
        case 0:
        case 1:
        case 2:
        case 3:
          _gameState[x][y] = 1;
          break;
        case 4:
        case 5:
          _gameState[x][y] = 2;
      }
    }
  }
    bool _hasChanged(List<List<int>> gameOld)
    {
      for(int i = 0; i < gameOld.length;i++) {
        for (int j = 0; j < gameOld.length; j++) {
          if (gameOld[i][j] != _gameState[i][j]) {
            return true;
          }
        }
      }
      return false;
    }
    void _shiftTop()
    {
      List<List<bool>> used = List<List<bool>>.generate(
          gameSize, (i) => List<bool>.generate(gameSize, (i) => false));
      for(int j = 0; j < gameSize; j++)
      {
        for(int i = 0; i < gameSize - 1; i++)
        {
          if( !used[i][j] && !used[i + 1][j]
              && _gameState[i][j] != 0
              && _gameState[i][j] == _gameState[i + 1][j]
          )
          {
            _gameState[i][j]++;
            _addPoint(_gameState[i][j]);
            _gameState[i + 1][j] = 0;
            used[i][j] = used[i + 1][j] = true;
          }
        }
      }

      for(int j = 0; j < gameSize; j++)
      {
        int top = 0;
        for(int i = 0; i < gameSize; i++)
        {
          if(_gameState[i][j] != 0) {
            if(top != i) {
              _gameState[top][j] = _gameState[i][j];
              _gameState[i][j] = 0;
            }
            top++;
          }
        }
      }
    }
  void _shiftBottom()
  {
    List<List<bool>> used = List<List<bool>>.generate(
        gameSize, (i) => List<bool>.generate(gameSize, (i) => false));
    for(int j = 0; j < gameSize; j++)
    {
      for(int i = gameSize - 1; i > 0; i--)
      {
        if( !used[i][j] && !used[i - 1][j]
            && _gameState[i][j] != 0
            && _gameState[i][j] == _gameState[i - 1][j]
        )
        {
          _gameState[i][j]++;
          _addPoint(_gameState[i][j]);
          _gameState[i - 1][j] = 0;
          used[i][j] = used[i - 1][j] = true;
        }
      }
    }

    for(int j = 0; j < gameSize; j++)
    {
      int bottom = gameSize-1;
      for(int i = gameSize-1; i >= 0; i--)
      {
        if(_gameState[i][j] != 0) {
          if(bottom != i) {
            _gameState[bottom][j] = _gameState[i][j];
            _gameState[i][j] = 0;
          }
          bottom--;
        }
      }
    }
  }

  void _shiftLeft()
  {
    List<List<bool>> used = List<List<bool>>.generate(
        gameSize, (i) => List<bool>.generate(gameSize, (i) => false));
    for(int i = 0; i < gameSize; i++)
    {
      for(int j = 0; j < gameSize-1; j++)
      {
        if( !used[i][j] && !used[i][j + 1]
            && _gameState[i][j] != 0
            && _gameState[i][j] == _gameState[i][j + 1]
        )
        {
          _gameState[i][j]++;
          _addPoint(_gameState[i][j]);
          _gameState[i][j + 1] = 0;
          used[i][j] = used[i][j + 1] = true;
        }
      }
    }

    for(int i = 0; i < gameSize; i++)
    {
      int left = 0;
      for(int j = 0; j < gameSize; j++)
      {
        if(_gameState[i][j] != 0) {
          if(left != j) {
            _gameState[i][left] = _gameState[i][j];
            _gameState[i][j] = 0;
          }
          left++;
        }
      }
    }
  }

  void _shiftRight()
  {
    List<List<bool>> used = List<List<bool>>.generate(
        gameSize, (i) => List<bool>.generate(gameSize, (i) => false));
    for(int i = 0; i < gameSize; i++)
    {
      for(int j = gameSize-1; j > 0; j--)
      {
        if( !used[i][j] && !used[i][j - 1]
            && _gameState[i][j] != 0
            && _gameState[i][j] == _gameState[i][j - 1]
        )
        {
          _gameState[i][j]++;
          _addPoint(_gameState[i][j]);
          _gameState[i][j - 1] = 0;
          used[i][j] = used[i][j - 1] = true;
        }
      }
    }

    for(int i = 0; i < gameSize; i++)
    {
      int right = gameSize - 1;
      for(int j = gameSize - 1; j >= 0; j--)
      {
        if(_gameState[i][j] != 0) {
          if(right != j) {
            _gameState[i][right] = _gameState[i][j];
            _gameState[i][j] = 0;
          }
          right--;
        }
      }
    }
  }
}



