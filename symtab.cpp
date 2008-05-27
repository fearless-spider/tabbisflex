#include <iostream>
#include <string>
#include "symtab.h"

void symtab::start() {
  symtab::add("_");
}

void symtab::add(string nowyElement) {
  try {
    if(symtab::szukaj(nowyElement) == 0) {
      entry tmp(nowyElement);
      elem_wej.push_back(tmp);
    } else
      throw 0;
  } catch( int x ) {
    printf("Element jest w tablicy\n\n");
  }
};

int symtab::szukaj(string search) {
  for ( int i = elem_wej.size()-1 ; i>0 ; i-- ) {
    if(elem_wej[i].name == search)
      return i;  
  }
  return 0; 
};

void symtab::ustaw_typ(int count, int now_wpis) {
  for( unsigned int tmp = elem_wej.size()-1; tmp > elem_wej.size()-count-1; tmp--)
    elem_wej[tmp].typ = now_wpis;
};

void symtab::ustaw_ref(int now_wpis) {
  if(now_wpis == Refer)
    elem_wej[elem_wej.size()-1].ref = Refer;
  else if(now_wpis == nRefer)
    elem_wej[elem_wej.size()-1].ref = nRefer;
};

void symtab::ustaw_zasieg(int count, int now_wpis) {
  for( unsigned int tmp = elem_wej.size()-1; tmp > elem_wej.size()-count-1; tmp--)
    if(now_wpis)
      elem_wej[elem_wej.size()-1].zasieg = now_wpis;
};


void symtab::ustaw_poczatekTablicy(int count, int now_wpis) {
  for( unsigned int tmp = elem_wej.size()-1; tmp > elem_wej.size()-count-1; tmp--)
    elem_wej[tmp].poczatekTablicy = now_wpis;
};

void symtab::ustaw_koniecTablicy(int count, int now_wpis) {
  for( unsigned int tmp = elem_wej.size()-1; tmp > elem_wej.size()-count-1; tmp--)
    elem_wej[tmp].koniecTablicy = now_wpis;
};

void symtab::ustaw_typTablicy(int count, int now_wpis) {
  for( unsigned int tmp = elem_wej.size()-1; tmp > elem_wej.size()-count-1; tmp--)
    elem_wej[tmp].typZwracany = now_wpis;
};

void symtab::ustaw_args(string function_name, int arg_number) {
  int tmp = symtab::szukaj(function_name);
  if(tmp)
    elem_wej[tmp].ileParametrow = arg_number;
};

void symtab::ustaw_typZwracany(string function_name, int type) {
  int tmp = symtab::szukaj(function_name);
  if(tmp)
    elem_wej[tmp].typZwracany = type;
};


void symtab::wypisz() {
  unsigned int i;
  printf("\nWygenerowana tablica: \n");
  for ( i = 1 ; i <= elem_wej.size()-1 ; i++ ) {
    cout << "\n nazwa zmiennej:\t" << elem_wej[i].name;
    switch(elem_wej[i].typ){
      case tInt :
        printf("\t typ INT ");
        break;
      case tReal :
        printf("\t typ REAL ");
        break;
      case tTablica :
        printf("\t typ ARRAY");
        break;
      case tFunkcja :
        printf("\t typ FUNC");
        break;
      default :
        break;
    }
    switch(elem_wej[i].ref) {
      case Refer :
        printf("\treference: TAK");
	break;
      case nRefer :
        printf("\treference: NIE");
	break;
      default :
        break;
    }
    switch(elem_wej[i].typ){
      case tTablica:
      //  cout << " [" << elem_wej[i].poczatekTablicy << ".." << elem_wej[i].koniecTablicy << "] of ";
        printf(" [%d..%d] typu ",elem_wej[i].poczatekTablicy,elem_wej[i].koniecTablicy );
        if(elem_wej[i].typZwracany == tInt)
	  printf("INT");
	else if(elem_wej[i].typZwracany == tReal)
	  printf("REAL");
        break;
      case tFunkcja:
        //cout << "\tParam no. : " << elem_wej[i].ileParametrow << "\t Returns : ";
        printf("ilosc parametrow %d  ", elem_wej[i].ileParametrow);
        if(elem_wej[i].typZwracany == tInt)
	  printf("INT");
	else if(elem_wej[i].typZwracany == tReal)
	  printf("REAL");
        break;
      default:
        break;
    }
  }
  cout << endl;
};

