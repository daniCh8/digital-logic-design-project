#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

//trasformo vettori binari in numeri interi
int bin_to_int(int* in) {
	int w, out=0; 
	for(w=0; w<8; w++) out+=(in[w]*pow(2, w)); 
	return out; 
}

int main() {
	int i, j, k, address=1, min=1000; 
	int cx[9], cy[9], d[8], m_input[8], m_output[8];
	
	FILE *f = fopen("testbench.txt", "w");
		
	srand(time(NULL));  
	
	//genero centroidi e punto di interesse in maniera randomica
	cx[8] = rand() % 256; 
	cy[8] = rand() % 256; 
	for(i=0; i<8; i++) {
		cx[i] = rand() % 256; 
		cy[i] = rand() % 256;
		m_input[i] = rand() % 2;  
		m_output[i] = 0; 
	}
	
	//per non avere sempre un solo centroide a distanza minima; 
	for(i=0; i<30; i++) {
		if((rand()%2)) {
		j = rand()%8; 
		k = rand()%8; 
		cx[j] = cx[k]; 
		cy[j] = cy[k];
	}
	}
	
	//calcolo le distanze dei centroidi attivi e quella minima; 
	for(i=0; i<8; i++) {
		if(m_input[i]) { 
			d[i] = ( cx[i]>cx[8] ? (cx[i]-cx[8]) : (cx[8]-cx[i]) ) + ( cy[i]>cy[8] ? (cy[i]-cy[8]) : (cy[8]-cy[i]) );
			if(d[i]<min) min = d[i]; 
		}
		else d[i] = 1000; 
	}
	
	//calcolo la maschera di output; 
	for(i=0; i<8; i++) if(m_input[i] && d[i]==min) m_output[i] = 1; 
	
	//genero il file txt con le informazioni necessarie; 
	fprintf(f, "signal RAM: ram_type := (0 => std_logic_vector(to_unsigned(%d, 8)),\n", bin_to_int(m_input));
	for(i=0; i<8; i++) {
		fprintf(f, "%d => std_logic_vector(to_unsigned(%d, 8)),\n", address, cx[i]);
		address++;
		fprintf(f, "%d => std_logic_vector(to_unsigned(%d, 8)),\n", address, cy[i]);
		address++; 
	}
	fprintf(f, "17 => std_logic_vector(to_unsigned(%d, 8)),\n", cx[8]);
	fprintf(f, "18 => std_logic_vector(to_unsigned(%d, 8)),\n", cy[8]);
	fprintf(f, "others => (others => '0'));\n");
	fprintf(f, "\n(...)\n\n--Maschera di output = %d%d%d%d%d%d%d%d\n", m_output[7], m_output[6], m_output[5], m_output[4], m_output[3], m_output[2], m_output[1], m_output[0]);
	fprintf(f, "assert RAM(19) = std_logic_vector(to_unsigned(%d, 8)) report %cTEST FALLITO%c severity failure;\n", bin_to_int(m_output), '"', '"');
	fclose(f); 
	
	return 0;	
}
