/* This is compiler design homework. */

/* To code,
   or not to code. */

// function declaration
int sub(int x, int y);

int main(){

  // variables
  int a;
  int b=1;
  double c=0;
  char d='x';

  // statements
  a = 10/2;
  c = (b+3)*4-5;
  b = sub(10,8);
  for (int i = 0; i <= 10; i++) {
    // Do nothing
  }
  for (int j = 0; j <= 100; j+=1) {
    // Do nothing
  }
  while (a >= 0) {
    a--;
    // Do nothing
  }
  while (a >= 0 && b == 2) {
    a--;
    // Do nothing
  }

  return a;

}

// function
int sub(int x, int y){
  return x-y;
}
