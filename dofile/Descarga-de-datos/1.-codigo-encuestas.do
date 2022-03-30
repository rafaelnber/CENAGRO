
*codigo de departamentos
clear 
input int codenc str20 departamento
337	"Amazonas"
338	"Ancash"
339	"Apurimac"
340	"Arequipa"
341 "Ayacucho"
342	"Cajamarca"
343	"Callao"
344	"Cusco"
345	"Huancavelica"
346	"Huanuco"
347	"Ica"
348	"Junin"
349	"La Libertad"
350	"Lambayeque"
351	"Lima"
352	"Loreto"
353	"Madre de Dios"
354	"Moquegua"
355 "Pasco"
356 "Piura"
357 "Puno"
358 "San Martin"
359 "Tacna"
360 "Tumbes"
361 "Ucayali"
end

**matrix codigo de CENAGRO 
mkmat codenc, mat(CENAGRO)
mat list CENAGRO



