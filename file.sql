-- lezione del 13 novembre 2014
-- oggi parliamo di... TRIGGER!!!

-- funzione 
create or replace function calcola_new_costo() 
    returns trigger as $$
    begin
        perform * from piatto_cost(NEW.piatto);
        return NEW;
    end;
$$ language plpgsql;

-- ora dobbiamo creare un trigger per associare questa funzione alla creazione
-- di un nuovo elemento... come? con un TRIGGER
create trigger ins_uso_prod
-- il trigger agisce AFTER l'inserimento del prodotto
-- in modo che abbia a disposizione i dati che gli servono per
-- calcolare il nuovo costo
	after insert on uso_prodotto
	for each row execute procedure calcola_new_costo();
	
create trigger update_fornitura
	after update on fornitura
	for each row execute procedure aggiorna_costo();
	
create or replace function aggiorna_costo()
	returns trigger as $$
	declare 
		p uso_prodotto.piatto%TYPE;
	begin
		if (OLD.costo_unitario <> NEW.costo_unitario) then
			for p in select piatto from uso_prodotto
			where prodotto = NEW.prodotto
			loop
				perform * from piatto_cost(p);
			end loop;
		end if;
	end;
$$ language plpgsql;
	
-- avvisa riordino merce quando inferiore alla soglia_riordino
create trigger controllo_riordino
	after update on prodotto
	for each row execute procedure avviso_riordino();
	
create or replace function avviso_riordino()
	returns trigger as $$
	begin
		if (NEW.soglia_riordino >= NEW.qnt_disponibile) then
			raise info 'La quantità del prodotto selezionato è scarsa, prego riordinare.';
		end if;
		return  NEW;
	end;
$$ language plpgsql;

-- scrivere un trigger e una funzione che
-- all'aggiunta di un piatto al menu aggiorni il menu
-- col costo del piatto incrementato del 20%
create or replace function calcola_prezzo()
	returns trigger as $$
	declare
		c piatto.costo%TYPE;
	begin
		select costo into c from piatto
			where id=NEW.piatto;
		NEW.prezzo_cliente := c + c * 0.2;
		return NEW;
	end;
$$ language plpgsql;

create trigger prezzo_menu
	before insert or update on menu_composizione
	for each row execute procedure calcola_prezzo();	






