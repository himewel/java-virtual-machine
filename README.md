# Java Virtual Machine

Projeto desenvolvido como trabalho para o componente curricular de Sistemas Digitais no curso de Engenharia de Computação da Universidade Federal do Pampa.

# Instruções

Os dados são armazenados na RAM, todos com 8 bits. A maioria das instruções são identificadas pelos 4 bits de maior magnitude, porém algumas chegam a considerar 5 bits.

- '0000' -> iconst_<n>: insere um inteiro na pilha. Se o 4º bit de menor magnitude for '1', os 3 bits seguintes, de menor magnitude definem o N positivo, do contrário N é negativo.

- '00010' -> bipush: insere um inteiro na pilha. O inteiro localizado na posição de memória seguinte é inserido na pilha.

- '00011' -> iload: carrega um inteiro da memória de dados para a pilha. O endereço de memória a ser carregado é informado na posição de memória seguinte.

- '00010' -> iload_<n>: carrega um inteiro da memória de dados para a pilha. O endereço de memória a ser carregado é informado no 3 bits de menor magnitude.
  
- '0011' -> istore: carrega para a memória de dados um inteiro da pilha. O endereço de memória a ser lido é informado na posição de memória seguinte.

- '0101' -> istore_<n>: carrega para a memória de dados um inteiro da pilha. O endereço de memória a ser lido é informado no 3 bits de menor magnitude.
  
- '0110' -> iadd, isub, imul: dois inteiros da pilha são carregados da pilha para a ULA. Os 2 bits de menor magnitude definem a operação a ser executada:
  - '00' -> iadd: soma dos dois inteiros;
  - '10' -> isub: subtração dos dois inteiros;
  - '01' -> imul: multiplicação dos dois inteiros.
  
- '1010' -> if_icmp: carrega dois inteiros e os compara. Se a comparação for verdadeira, pula as duas posições de memória seguintes que guardam os endereços para o salto. Se falsa, carrega os dois valores nos endereços seguintes e realiza o salto no PC. Os 4 bits de menor magnitude definem qual comparação será realizada:
  - '1111' -> if_icmpEQ: igual;
  - '0000' -> if_icmpNE: não igual;
  - '0001' -> if_icmpLT: menor;
  - '0010' -> if_icmpGE: maior ou igual;
  - '0011' -> if_icmpGT: maior;
  - '0100' -> if_icmpLE: menor ou igual.
  
- '1011' -> goto: realiza um salto incondicional com os inteiros das duas posições seguintes da memória.

- '1100' -> goto_w: realiza um salto incondicional com os inteiros das quatro posições seguintes da memória.
  
