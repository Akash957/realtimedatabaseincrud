void main() {
  List<int> num = [1, 8, 3, 5, 4544];
  var max = num[0];
  var p = 0;
  for (int a = 0; a < num.length; a++) {
    if (max < num[a]) {
      max = num[a];
    }
  }
  for (int b = 1; b <= max; b++) {
    if (b % max == 0) {
      p++;
    }
  }
  if (p <= 2) {
    print("$max is prime");
  }
}
