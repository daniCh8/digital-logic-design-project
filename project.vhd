library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic; 
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
        );
end project_reti_logiche;

architecture arch of project_reti_logiche is
    type fsm_type is (idle, start, takex, takey, mem, c0x, c0y, c0, c0d, c1x, c1y, c1, c1d, c2x, c2y, c2, c2d, c3x, c3y, c3, c3d, c4x, c4y, c4, c4d, c5x, c5y, c5, c5d, c6x, c6y, c6, c6d, c7x, c7y, c7, c7d, comp_min, comp, stop, done);
    signal ss, ss_next: fsm_type;
    signal c_attivi, c_attivi_tmp, risultato, risultato_tmp : std_logic_vector(7 downto 0);
    signal d0, d1, d2, d3, d4, d5, d6, d7, d0_tmp, d1_tmp, d2_tmp, d3_tmp, d4_tmp, d5_tmp, d6_tmp, d7_tmp : unsigned(8 downto 0);
    signal x, y, xc, yc, x_tmp, y_tmp, xc_tmp, yc_tmp : unsigned(7 downto 0);
    signal min, min_tmp : unsigned(8 downto 0);
begin
    -- Assegnamento ss al cambio di clock
    process(i_clk, i_rst, i_start)
    begin
        if(i_rst='1' or i_start='0') then
            ss <= idle;
        elsif(i_clk'event and i_clk='1') then
            ss <= ss_next;
            x_tmp <= x; 
            y_tmp <= y;
            xc_tmp <= xc; 
            yc_tmp <= yc;
            d0_tmp <= d0;
            d1_tmp <= d1; 
            d2_tmp <= d2;
            d3_tmp <= d3;
            d4_tmp <= d4; 
            d5_tmp <= d5;
            d6_tmp <= d6;
            d7_tmp <= d7;  
            min_tmp <= min; 
            risultato_tmp <= risultato;
            c_attivi_tmp <= c_attivi;   
           end if; 
    end process; 
    
    -- Assegnamento ss_next
    process(ss, i_start, c_attivi)
    begin
        ss_next <= ss; 
        case ss is
            when idle =>
                if(i_start='1') then
                    ss_next <= start;
                end if;
            when start =>
                    ss_next <= takex;
            when takex =>
                    ss_next <= takey;
            when takey =>
                    ss_next <= mem;
            when mem =>
                    ss_next <= c0x;
            when c0x => 
                    ss_next <= c0y; 
            when c0y => 
                    ss_next <= c0; 
            when c0 => 
                    ss_next <= c0d; 
            when c0d =>
                    ss_next <= c1x;
            when c1x => 
                    ss_next <= c1y; 
            when c1y => 
                    ss_next <= c1; 
            when c1 => 
                    ss_next <= c1d; 
            when c1d =>
                    ss_next <= c2x;
            when c2x => 
                    ss_next <= c2y; 
            when c2y => 
                    ss_next <= c2; 
            when c2 => 
                    ss_next <= c2d; 
            when c2d =>
                    ss_next <= c3x;
            when c3x => 
                    ss_next <= c3y; 
            when c3y => 
                    ss_next <= c3; 
            when c3 => 
                    ss_next <= c3d; 
            when c3d =>
                    ss_next <= c4x;
            when c4x => 
                    ss_next <= c4y; 
            when c4y => 
                    ss_next <= c4; 
            when c4 => 
                    ss_next <= c4d; 
            when c4d =>
                    ss_next <= c5x;
            when c5x => 
                    ss_next <= c5y; 
            when c5y => 
                    ss_next <= c5; 
            when c5 => 
                    ss_next <= c5d; 
            when c5d =>
                    ss_next <= c6x;
            when c6x => 
                    ss_next <= c6y; 
            when c6y => 
                    ss_next <= c6; 
            when c6 => 
                    ss_next <= c6d; 
            when c6d =>
                    ss_next <= c7x;
            when c7x => 
                    ss_next <= c7y; 
            when c7y => 
                    ss_next <= c7; 
            when c7 => 
                    ss_next <= c7d; 
            when c7d =>
                    ss_next <= comp_min;
            when comp_min =>
                    ss_next <= comp;
            when comp =>
                    ss_next <= stop;
            when stop =>
                    ss_next <= done;
            when done =>
        end case;
    end process; 
    
    -- Computazione Interna Stati
    process(ss, i_data, c_attivi, x, y, x_tmp, y_tmp, xc_tmp, yc_tmp, d0_tmp, d1_tmp, d2_tmp, d3_tmp, d4_tmp, d5_tmp, d6_tmp, d7_tmp, min_tmp, risultato_tmp, c_attivi_tmp, xc, yc, c_attivi, d0, d1, d2, d3, d4, d5, d6, d7, min, risultato)
    begin
        o_data <= (others => 'X');   
        o_address <= (others => 'X');
        o_we <= '0';
        o_en <= '0'; 
        o_done <= '0';
        risultato <= (others => '0');
        x <= x_tmp; 
        y <= y_tmp;
        xc <= xc_tmp;
        yc <= yc_tmp;
        d0 <= d0_tmp;
        d1 <= d1_tmp;
        d2 <= d2_tmp;
        d3 <= d3_tmp;
        d4 <= d4_tmp;
        d5 <= d5_tmp;
        d6 <= d6_tmp;
        d7 <= d7_tmp;
        min <= min_tmp; 
        risultato <= risultato_tmp;
        c_attivi <= c_attivi_tmp;  
        case ss is
            when idle =>
            when start =>
                risultato <= "00000000";
                min <= "111111111";
                o_en <= '1';
                o_address <= (others => '0'); 
            when takex =>
                c_attivi <= i_data;
                o_en <= '1';
                o_address <= "0000000000010001";
            when takey =>
                x <= unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000010010";
            when mem => 
                y <= unsigned(i_data);
            when c0x =>
                o_en <= '1';
                o_address <= "0000000000000001";
            when c0y =>
                xc <= unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000000010";
            when c0 =>
                yc <= unsigned(i_data);
            when c0d =>
                if(c_attivi(0)='0') then d0 <= "111111111";
                    elsif(xc>=x and yc>=y) then d0 <= ('0'&(xc-x))+('0'&(yc-y));
                    elsif(xc<=x and yc>=y) then d0 <= ('0'&(x-xc))+('0'&(yc-y));
                    elsif(xc<=x and yc<=y) then d0 <= ('0'&(x-xc))+('0'&(y-yc));
                    elsif(xc>=x and yc<=y) then d0 <= ('0'&(xc-x))+('0'&(y-yc));
                end if;
            when c1x =>
                o_en <= '1';
                o_address <= "0000000000000011";
            when c1y =>
                xc <= unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000000100";
            when c1 =>
                yc <= unsigned(i_data);
            when c1d =>
                if(c_attivi(1)='0') then d1 <= "111111111";
                    elsif(xc>=x and yc>=y) then d1 <= ('0'&(xc-x))+('0'&(yc-y));
                    elsif(xc<=x and yc>=y) then d1 <= ('0'&(x-xc))+('0'&(yc-y));
                    elsif(xc<=x and yc<=y) then d1 <= ('0'&(x-xc))+('0'&(y-yc));
                    elsif(xc>=x and yc<=y) then d1 <= ('0'&(xc-x))+('0'&(y-yc));
                end if;
            when c2x =>
                o_en <= '1';
                o_address <= "0000000000000101";
            when c2y =>
                xc <= unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000000110";
            when c2 =>
                yc <= unsigned(i_data);
            when c2d =>
                if(c_attivi(2)='0') then d2 <= "111111111";
                    elsif(xc>=x and yc>=y) then d2 <= ('0'&(xc-x))+('0'&(yc-y));
                    elsif(xc<=x and yc>=y) then d2 <= ('0'&(x-xc))+('0'&(yc-y));
                    elsif(xc<=x and yc<=y) then d2 <= ('0'&(x-xc))+('0'&(y-yc));
                    elsif(xc>=x and yc<=y) then d2 <= ('0'&(xc-x))+('0'&(y-yc));
                end if;
            when c3x =>
                o_en <= '1';
                o_address <= "0000000000000111";
            when c3y =>
                xc <= unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000001000";
            when c3 =>
                yc <= unsigned(i_data);
            when c3d =>
                if(c_attivi(3)='0') then d3 <= "111111111";
                    elsif(xc>=x and yc>=y) then d3 <= ('0'&(xc-x))+('0'&(yc-y));
                    elsif(xc<=x and yc>=y) then d3 <= ('0'&(x-xc))+('0'&(yc-y));
                    elsif(xc<=x and yc<=y) then d3 <= ('0'&(x-xc))+('0'&(y-yc));
                    elsif(xc>=x and yc<=y) then d3 <= ('0'&(xc-x))+('0'&(y-yc));
                end if;
            when c4x =>
                o_en <= '1';
                o_address <= "0000000000001001";
            when c4y =>
                xc <= unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000001010";
            when c4 =>
                yc <= unsigned(i_data);
            when c4d =>
                if(c_attivi(4)='0') then d4 <= "111111111";
                    elsif(xc>=x and yc>=y) then d4 <= ('0'&(xc-x))+('0'&(yc-y));
                    elsif(xc<=x and yc>=y) then d4 <= ('0'&(x-xc))+('0'&(yc-y));
                    elsif(xc<=x and yc<=y) then d4 <= ('0'&(x-xc))+('0'&(y-yc));
                    elsif(xc>=x and yc<=y) then d4 <= ('0'&(xc-x))+('0'&(y-yc));
                end if;
            when c5x =>
                o_en <= '1';
                o_address <= "0000000000001011";
            when c5y =>
                xc <= unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000001100";
            when c5 =>
                yc <= unsigned(i_data);
            when c5d =>
                if(c_attivi(5)='0') then d5 <= "111111111";
                    elsif(xc>=x and yc>=y) then d5 <= ('0'&(xc-x))+('0'&(yc-y));
                    elsif(xc<=x and yc>=y) then d5 <= ('0'&(x-xc))+('0'&(yc-y));
                    elsif(xc<=x and yc<=y) then d5 <= ('0'&(x-xc))+('0'&(y-yc));
                    elsif(xc>=x and yc<=y) then d5 <= ('0'&(xc-x))+('0'&(y-yc));
                end if;
            when c6x =>
                o_en <= '1';
                o_address <= "0000000000001101";
            when c6y =>
                xc <= unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000001110";
            when c6 =>
                yc <= unsigned(i_data);
            when c6d =>
                if(c_attivi(6)='0') then d6 <= "111111111";
                    elsif(xc>=x and yc>=y) then d6 <= ('0'&(xc-x))+('0'&(yc-y));
                    elsif(xc<=x and yc>=y) then d6 <= ('0'&(x-xc))+('0'&(yc-y));
                    elsif(xc<=x and yc<=y) then d6 <= ('0'&(x-xc))+('0'&(y-yc));
                    elsif(xc>=x and yc<=y) then d6 <= ('0'&(xc-x))+('0'&(y-yc));
                end if;
            when c7x =>
                o_en <= '1';
                o_address <= "0000000000001111";
            when c7y =>
                xc <= unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000010000";
            when c7 =>
                yc <= unsigned(i_data);
            when c7d =>
                if(c_attivi(7)='0') then d7 <= "111111111";
                    elsif(xc>=x and yc>=y) then d7 <= ('0'&(xc-x))+('0'&(yc-y));
                    elsif(xc<=x and yc>=y) then d7 <= ('0'&(x-xc))+('0'&(yc-y));
                    elsif(xc<=x and yc<=y) then d7 <= ('0'&(x-xc))+('0'&(y-yc));
                    elsif(xc>=x and yc<=y) then d7 <= ('0'&(xc-x))+('0'&(y-yc));
                end if;
            when comp_min =>
                if(c_attivi(0)='1' and d0<=d1 and d0<=d2 and d0<=d3 and d0<=d4 and d0<=d5 and d0<=d6 and d0<=d7) then min <= d0;
                    elsif(c_attivi(1)='1' and d1<=d2 and d1<=d3 and d1<=d4 and d1<=d5 and d1<=d6 and d1<=d7) then min <= d1;
                    elsif(c_attivi(2)='1' and d2<=d3 and d2<=d4 and d2<=d5 and d2<=d6 and d2<=d7) then min <= d2; 
                    elsif(c_attivi(3)='1' and d3<=d4 and d3<=d5 and d3<=d6 and d3<=d7) then min <= d3; 
                    elsif(c_attivi(4)='1' and d4<=d5 and d4<=d6 and d4<=d7) then min <= d4;
                    elsif(c_attivi(5)='1' and d5<=d6 and d5<=d7) then min <= d5; 
                    elsif(c_attivi(6)='1' and d6<=d7) then min <= d6; 
                    elsif(c_attivi(7)='1') then min <= d7;
                end if;  
            when comp =>
                if(c_attivi="00000000") then 
                        risultato <= "00000000"; 
                    end if;
                if(c_attivi(0)='1' and d0=min) then 
                        risultato(0) <= '1';
                    end if;
                if(c_attivi(1)='1' and d1=min) then 
                        risultato(1) <= '1';
                    end if;
                if(c_attivi(2)='1' and d2=min) then 
                        risultato(2) <= '1';
                    end if;
                if(c_attivi(3)='1' and d3=min) then 
                        risultato(3) <= '1';
                    end if;
                if(c_attivi(4)='1' and d4=min) then 
                        risultato(4) <= '1';
                    end if;
                if(c_attivi(5)='1' and d5=min) then 
                        risultato(5) <= '1';
                    end if;
                if(c_attivi(6)='1' and d6=min) then 
                        risultato(6) <= '1';
                    end if;
                if(c_attivi(7)='1' and d7=min) then 
                        risultato(7) <= '1';
                    end if; 
            when stop =>
                o_we <= '1'; 
                o_en <= '1';
                o_data <= std_logic_vector(risultato);
                o_address <= "0000000000010011";
            when done => 
                o_done <= '1';
        end case; 
    end process; 
end arch;    
             