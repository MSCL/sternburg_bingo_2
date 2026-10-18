const int bingoMinNumber = 1;
const int bingoMaxNumber = 99;
const int bingoGridCrossAxisCount = 5;
const int bingoNumberPadLength = 2;

String formatBingoNumber(int number) =>
    number.toString().padLeft(bingoNumberPadLength, '0');
