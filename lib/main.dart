import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _arr = [];
  StreamController<List<int>> _streamController = StreamController();
  String _currentSortAlgo = 'bubble';
  double _size = 500;
  bool isSorted = false;
  bool isSorting = false;
  int speed = 0;
  static int duration = 1500;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Duration _getDuration() {
    return Duration(microseconds: duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _size = MediaQuery.of(context).size.width / 2;
    for (int i = 0; i < _size; ++i) {
      _arr.add(Random().nextInt(500));
    }
    setState(() {});
  }

  _bubbleSort() async {
    for (int i = 0; i < _arr.length; ++i) {
      for (int j = 0; j < _arr.length - i - 1; ++j) {
        if (_arr[j] > _arr[j + 1]) {
          int temp = _arr[j];
          _arr[j] = _arr[j + 1];
          _arr[j + 1] = temp;
        }

        await Future.delayed(_getDuration(), () {});

        _streamController.add(_arr);
      }
    }
  }

  _recursiveBubbleSort(int n) async {
    if (n == 1) {
      return;
    }
    for (int i = 0; i < n - 1; i++) {
      if (_arr[i] > _arr[i + 1]) {
        int temp = _arr[i];
        _arr[i] = _arr[i + 1];
        _arr[i + 1] = temp;
      }
      await Future.delayed(_getDuration());
      _streamController.add(_arr);
    }
    await _recursiveBubbleSort(n - 1);
  }

  _selectionSort() async {
    for (int i = 0; i < _arr.length; i++) {
      for (int j = i + 1; j < _arr.length; j++) {
        if (_arr[i] > _arr[j]) {
          int temp = _arr[j];
          _arr[j] = _arr[i];
          _arr[i] = temp;
        }

        await Future.delayed(_getDuration(), () {});

        _streamController.add(_arr);
      }
    }
  }

  _heapSort() async {
    for (int i = _arr.length ~/ 2; i >= 0; i--) {
      await heapify(_arr, _arr.length, i);
      _streamController.add(_arr);
    }
    for (int i = _arr.length - 1; i >= 0; i--) {
      int temp = _arr[0];
      _arr[0] = _arr[i];
      _arr[i] = temp;
      await heapify(_arr, i, 0);
      _streamController.add(_arr);
    }
  }

  heapify(List<int> arr, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && arr[l] > arr[largest]) largest = l;

    if (r < n && arr[r] > arr[largest]) largest = r;

    if (largest != i) {
      int temp = _arr[i];
      _arr[i] = _arr[largest];
      _arr[largest] = temp;
      heapify(arr, n, largest);
    }
    await Future.delayed(_getDuration());
  }

  _insertionSort() async {
    for (int i = 1; i < _arr.length; i++) {
      int temp = _arr[i];
      int j = i - 1;
      while (j >= 0 && temp < _arr[j]) {
        _arr[j + 1] = _arr[j];
        --j;
        await Future.delayed(_getDuration(), () {});

        _streamController.add(_arr);
      }
      _arr[j + 1] = temp;
      await Future.delayed(_getDuration(), () {});

      _streamController.add(_arr);
    }
  }

  cf(int a, int b) {
    if (a < b) {
      return -1;
    } else if (a > b) {
      return 1;
    } else {
      return 0;
    }
  }

  _quickSort(int leftIndex, int rightIndex) async {
    Future<int> _partition(int left, int right) async {
      int p = (left + (right - left) / 2).toInt();

      var temp = _arr[p];
      _arr[p] = _arr[right];
      _arr[right] = temp;
      await Future.delayed(_getDuration(), () {});

      _streamController.add(_arr);

      int cursor = left;

      for (int i = left; i < right; i++) {
        if (cf(_arr[i], _arr[right]) <= 0) {
          var temp = _arr[i];
          _arr[i] = _arr[cursor];
          _arr[cursor] = temp;
          cursor++;

          await Future.delayed(_getDuration(), () {});

          _streamController.add(_arr);
        }
      }

      temp = _arr[right];
      _arr[right] = _arr[cursor];
      _arr[cursor] = temp;

      await Future.delayed(_getDuration(), () {});

      _streamController.add(_arr);

      return cursor;
    }

    if (leftIndex < rightIndex) {
      int p = await _partition(leftIndex, rightIndex);

      await _quickSort(leftIndex, p - 1);

      await _quickSort(p + 1, rightIndex);
    }
  }

  _mergeSort(int leftIndex, int rightIndex) async {
    Future<void> merge(int leftIndex, int middleIndex, int rightIndex) async {
      int leftSize = middleIndex - leftIndex + 1;
      int rightSize = rightIndex - middleIndex;

      List leftList = new List(leftSize);
      List rightList = new List(rightSize);

      for (int i = 0; i < leftSize; i++) leftList[i] = _arr[leftIndex + i];
      for (int j = 0; j < rightSize; j++)
        rightList[j] = _arr[middleIndex + j + 1];

      int i = 0, j = 0;
      int k = leftIndex;

      while (i < leftSize && j < rightSize) {
        if (leftList[i] <= rightList[j]) {
          _arr[k] = leftList[i];
          i++;
        } else {
          _arr[k] = rightList[j];
          j++;
        }

        await Future.delayed(_getDuration(), () {});
        _streamController.add(_arr);

        k++;
      }

      while (i < leftSize) {
        _arr[k] = leftList[i];
        i++;
        k++;

        await Future.delayed(_getDuration(), () {});
        _streamController.add(_arr);
      }

      while (j < rightSize) {
        _arr[k] = rightList[j];
        j++;
        k++;

        await Future.delayed(_getDuration(), () {});
        _streamController.add(_arr);
      }
    }

    if (leftIndex < rightIndex) {
      int middleIndex = (rightIndex + leftIndex) ~/ 2;

      await _mergeSort(leftIndex, middleIndex);
      await _mergeSort(middleIndex + 1, rightIndex);

      await Future.delayed(_getDuration(), () {});

      _streamController.add(_arr);

      await merge(leftIndex, middleIndex, rightIndex);
    }
  }

  _shellSort() async {
    for (int gap = _arr.length ~/ 2; gap > 0; gap ~/= 2) {
      for (int i = gap; i < _arr.length; i += 1) {
        int temp = _arr[i];
        int j;
        for (j = i; j >= gap && _arr[j - gap] > temp; j -= gap)
          _arr[j] = _arr[j - gap];
        _arr[j] = temp;
        await Future.delayed(_getDuration());
        _streamController.add(_arr);
      }
    }
  }

  int getNextGap(int gap) {
    gap = (gap * 10) ~/ 13;

    if (gap < 1) return 1;
    return gap;
  }

  _combSort() async {
    int gap = _arr.length;

    bool swapped = true;

    while (gap != 1 || swapped == true) {
      gap = getNextGap(gap);

      swapped = false;

      for (int i = 0; i < _arr.length - gap; i++) {
        if (_arr[i] > _arr[i + gap]) {
          int temp = _arr[i];
          _arr[i] = _arr[i + gap];
          _arr[i + gap] = temp;
          swapped = true;
        }
        await Future.delayed(_getDuration());
        _streamController.add(_arr);
      }
    }
  }

  _pigeonHole() async {
    int min = _arr[0];
    int max = _arr[0];
    int range, i, j, index;
    for (int a = 0; a < _arr.length; a++) {
      if (_arr[a] > max) max = _arr[a];
      if (_arr[a] < min) min = _arr[a];
    }
    range = max - min + 1;
    List<int> phole = new List.generate(range, (i) => 0);

    for (i = 0; i < _arr.length; i++) {
      phole[_arr[i] - min]++;
    }

    index = 0;

    for (j = 0; j < range; j++) {
      while (phole[j]-- > 0) {
        _arr[index++] = j + min;
        await Future.delayed(_getDuration());
        _streamController.add(_arr);
      }
    }
  }

  _cycleSort() async {
    int writes = 0;
    for (int cycleStart = 0; cycleStart <= _arr.length - 2; cycleStart++) {
      int item = _arr[cycleStart];
      int pos = cycleStart;
      for (int i = cycleStart + 1; i < _arr.length; i++) {
        if (_arr[i] < item) pos++;
      }

      if (pos == cycleStart) {
        continue;
      }

      while (item == _arr[pos]) {
        pos += 1;
      }

      if (pos != cycleStart) {
        int temp = item;
        item = _arr[pos];
        _arr[pos] = temp;
        writes++;
      }

      while (pos != cycleStart) {
        pos = cycleStart;
        for (int i = cycleStart + 1; i < _arr.length; i++) {
          if (_arr[i] < item) pos += 1;
        }

        while (item == _arr[pos]) {
          pos += 1;
        }

        if (item != _arr[pos]) {
          int temp = item;
          item = _arr[pos];
          _arr[pos] = temp;
          writes++;
        }
        await Future.delayed(_getDuration());
        _streamController.add(_arr);
      }
    }
  }

  _cocktailSort() async {
    bool swapped = true;
    int start = 0;
    int end = _arr.length;

    while (swapped == true) {
      swapped = false;
      for (int i = start; i < end - 1; ++i) {
        if (_arr[i] > _arr[i + 1]) {
          int temp = _arr[i];
          _arr[i] = _arr[i + 1];
          _arr[i + 1] = temp;
          swapped = true;
        }
        await Future.delayed(_getDuration());
        _streamController.add(_arr);
      }
      if (swapped == false) break;
      swapped = false;
      end = end - 1;
      for (int i = end - 1; i >= start; i--) {
        if (_arr[i] > _arr[i + 1]) {
          int temp = _arr[i];
          _arr[i] = _arr[i + 1];
          _arr[i + 1] = temp;
          swapped = true;
        }
        await Future.delayed(_getDuration());
        _streamController.add(_arr);
      }
      start = start + 1;
    }
  }

  _gnomeSort() async {
    int index = 0;

    while (index < _arr.length) {
      if (index == 0) index++;
      if (_arr[index] >= _arr[index - 1])
        index++;
      else {
        int temp = _arr[index];
        _arr[index] = _arr[index - 1];
        _arr[index - 1] = temp;

        index--;
      }
      await Future.delayed(_getDuration());
      _streamController.add(_arr);
    }
    return;
  }

  _stoogesort(int l, int h) async {
    if (l >= h) return;

    if (_arr[l] > _arr[h]) {
      int temp = _arr[l];
      _arr[l] = _arr[h];
      _arr[h] = temp;
      await Future.delayed(_getDuration());
      _streamController.add(_arr);
    }

    if (h - l + 1 > 2) {
      int t = (h - l + 1) ~/ 3;
      await _stoogesort(l, h - t);
      await _stoogesort(l + t, h);
      await _stoogesort(l, h - t);
    }
  }

  _oddEvenSort() async {
    bool isSorted = false;

    while (!isSorted) {
      isSorted = true;

      for (int i = 1; i <= _arr.length - 2; i = i + 2) {
        if (_arr[i] > _arr[i + 1]) {
          int temp = _arr[i];
          _arr[i] = _arr[i + 1];
          _arr[i + 1] = temp;
          isSorted = false;
          await Future.delayed(_getDuration());
          _streamController.add(_arr);
        }
      }

      for (int i = 0; i <= _arr.length - 2; i = i + 2) {
        if (_arr[i] > _arr[i + 1]) {
          int temp = _arr[i];
          _arr[i] = _arr[i + 1];
          _arr[i + 1] = temp;
          isSorted = false;
          await Future.delayed(_getDuration());
          _streamController.add(_arr);
        }
      }
    }

    return;
  }

  _reset() {
    isSorted = false;
    _arr = [];
    for (int i = 0; i < _size; ++i) {
      _arr.add(Random().nextInt(500));
    }
    _streamController.add(_arr);
  }

  _setSortAlgo(String type) {
    setState(() {
      _currentSortAlgo = type;
    });
  }

  _checkAndResetIfSorted() async {
    if (isSorted) {
      _reset();
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  String _getTitle() {
    switch (_currentSortAlgo) {
      case "bubble":
        return "Bubble Sort";
        break;
      case "coctail":
        return "Coctail Sort";
        break;
      case "pigeonhole":
        return "Pigeonhole Sort";
        break;
      case "recursivebubble":
        return "Recursive Bubble Sort";
        break;
      case "heap":
        return "Heap Sort";
        break;
      case "selection":
        return "Selection Sort";
        break;
      case "insertion":
        return "Insertion Sort";
        break;
      case "quick":
        return "Quick Sort";
        break;
      case "merge":
        return "Merge Sort";
        break;
      case "shell":
        return "Shell Sort";
        break;
      case "comb":
        return "Comb Sort";
        break;
      case "cycle":
        return "Cycle Sort";
        break;
      case "gnome":
        return "Gnome Sort";
        break;
      case "stooge":
        return "Stooge Sort";
        break;
      case "oddeven":
        return "Odd Even Sort";
        break;
    }
  }

  _speedShift() {
    if (speed >= 3) {
      speed = 0;
      duration = 1500;
    } else {
      speed++;
      duration = duration ~/ 2;
    }

    print(speed.toString() + " " + duration.toString());
    setState(() {});
  }

  _sort() async {
    setState(() {
      isSorting = true;
    });

    await _checkAndResetIfSorted();

    Stopwatch stopwatch = new Stopwatch()..start();

    switch (_currentSortAlgo) {
      case "comb":
        await _combSort();
        break;
      case "coctail":
        await _cocktailSort();
        break;
      case "bubble":
        await _bubbleSort();
        break;
      case "pigeonhole":
        await _pigeonHole();
        break;
      case "shell":
        await _shellSort();
        break;
      case "recursivebubble":
        await _recursiveBubbleSort(_size.toInt() - 1);
        break;
      case "selection":
        await _selectionSort();
        break;
      case "cycle":
        await _cycleSort();
        break;
      case "heap":
        await _heapSort();
        break;
      case "insertion":
        await _insertionSort();
        break;
      case "gnome":
        await _gnomeSort();
        break;
      case "oddeven":
        await _oddEvenSort();
        break;
      case "stooge":
        await _stoogesort(0, _size.toInt() - 1);
        break;
      case "quick":
        await _quickSort(0, _size.toInt() - 1);
        break;
      case "merge":
        await _mergeSort(0, _size.toInt() - 1);
        break;
    }

    stopwatch.stop();

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          "Sorting completed in ${stopwatch.elapsed.inMilliseconds} ms.",
        ),
      ),
    );
    setState(() {
      isSorting = false;
      isSorted = true;
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_getTitle()),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          PopupMenuButton<String>(
            initialValue: _currentSortAlgo,
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                  value: 'bubble',
                  child: Text("Bubble Sort"),
                ),
                PopupMenuItem(
                  value: 'recursivebubble',
                  child: Text("R-Bubble Sort"),
                ),
                PopupMenuItem(
                  value: 'heap',
                  child: Text("Heap Sort"),
                ),
                PopupMenuItem(
                  value: 'selection',
                  child: Text("Selection Sort"),
                ),
                PopupMenuItem(
                  value: 'insertion',
                  child: Text("Insertion Sort"),
                ),
                PopupMenuItem(
                  value: 'quick',
                  child: Text("Quick Sort"),
                ),
                PopupMenuItem(
                  value: 'merge',
                  child: Text("Merge Sort"),
                ),
                PopupMenuItem(
                  value: 'shell',
                  child: Text("Shell Sort"),
                ),
                PopupMenuItem(
                  value: 'comb',
                  child: Text("Comb Sort"),
                ),
                PopupMenuItem(
                  value: 'pigeonhole',
                  child: Text("Pigeonhole Sort"),
                ),
                PopupMenuItem(
                  value: 'cycle',
                  child: Text("Cycle Sort"),
                ),
                PopupMenuItem(
                  value: 'coctail',
                  child: Text("Coctail Sort"),
                ),
                PopupMenuItem(
                  value: 'gnome',
                  child: Text("Gnome Sort"),
                ),
                PopupMenuItem(
                  value: 'stooge',
                  child: Text("Stooge Sort"),
                ),
                PopupMenuItem(
                  value: 'oddeven',
                  child: Text("Odd Even Sort"),
                ),
              ];
            },
            onSelected: (String value) {
              _reset();
              _setSortAlgo(value);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 0.0),
          child: StreamBuilder<Object>(
              initialData: _arr,
              stream: _streamController.stream,
              builder: (context, snapshot) {
                List<int> numbers = snapshot.data;
                int counter = 0;

                return Row(
                  children: numbers.map((int num) {
                    counter++;
                    return Container(
                      child: CustomPaint(
                        painter: Bars(
                            index: counter,
                            value: num,
                            width: MediaQuery.of(context).size.width / _size),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF34495e), Color(0xFF9b59b6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: FlatButton(
                  onPressed: isSorting
                      ? null
                      : () {
                          _reset();
                          _setSortAlgo(_currentSortAlgo);
                        },
                  child: Text(
                    "RESET",
                    style: TextStyle(color: Colors.black),
                  )),
            )),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xFF34495e),
                Color(0xFF2980b9),
                Color(0xFF9b59b6),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: FlatButton(
                  onPressed: isSorting ? null : _sort,
                  child: Text(
                    "SORT",
                    style: TextStyle(color: Colors.black),
                  )),
            )),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF34495e), Color(0xFF9b59b6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: FlatButton(
                  onPressed: isSorting ? null : _speedShift,
                  child: Text(
                    "${speed + 1}x",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )),
            )),
          ],
        ),
      ),
    );
  }
}

class Bars extends CustomPainter {
  final double width;
  final int value;
  final int index;
  Bars({this.width, this.value, this.index});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    if (value < 500 * 0.1) {
      paint.color = Colors.blue[100];
    } else if (value < 500 * 0.2) {
      paint.color = Colors.blue[200];
    } else if (value < 500 * 0.3) {
      paint.color = Colors.blue[300];
    } else if (value < 500 * 0.4) {
      paint.color = Colors.blue[400];
    } else if (value < 500 * 0.5) {
      paint.color = Colors.blue[500];
    } else if (value < 500 * 0.6) {
      paint.color = Colors.blue[600];
    } else if (value < 500 * 0.7) {
      paint.color = Colors.blue[700];
    } else if (value < 500 * 0.8) {
      paint.color = Colors.blue[800];
    } else if (value < 500 * 0.9) {
      paint.color = Colors.blue[900];
    } else {
      paint.color = Color(0xFF00008B);
    }

    paint.strokeWidth = width;
    paint.strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, value.ceilToDouble()), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
