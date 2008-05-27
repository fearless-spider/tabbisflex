#include <iostream>
#include <vector>
#include <string>

using namespace std;

enum{ NONE, tInt, tReal, tTablica, tFunkcja, tProcedura, Refer, nRefer};

struct entry {
  string name;
  int typ;		// enum used
  int ref;		// reference ( parameter ) or no
  string addr;		// in memory
  int zasieg;		// 0 (not set) is global, higher numbers are local
  int ileParametrow;		// number of parameters for function / procedure
  int typZwracany;		// array type for array & return type for a function
  int poczatekTablicy;
  int koniecTablicy;		// indices for an array declaration
  // constructor
  entry(string new_name){name = new_name; typ = 0; ref =0; addr= "none"; zasieg=0; ileParametrow=0; typZwracany=0;};
  ~entry(){};
};

class symtab {
  vector<entry> elem_wej;
public :
  void start();
  int szukaj(string);
  void add(string);
  void wypisz();

  void ustaw_typ(int,int);
  void ustaw_ref(int);
  void ustaw_zasieg(int,int);
  void ustaw_poczatekTablicy(int,int);
  void ustaw_koniecTablicy(int,int);
  void ustaw_typTablicy(int,int);
 
  void ustaw_args(string,int);
  void ustaw_typZwracany(string,int);
} symtab;
