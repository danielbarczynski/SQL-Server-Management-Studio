/*23/2.01a
Nazwy wszystkich katedr, w których pracuje co najmniej jeden wyk³adowca (w pierwszej kolumnie), trzy tytu³y naukowe: doctor, 
master, full professor (w pierwszym wierszu) oraz liczbê godzin zajêæ prowadzonych w ramach ka¿dej katedry przez ka¿d¹ z tych 
trzech grup pracowników. U¿yj sk³adni CTE. 8 rekordów.
W Department of Economics tylko pracownicy master prowadz¹ zajêcia (60 godzin)
W Department of Informatics doctors maj¹ 15 godzin, masters 12 a full professors 30*/

with pd as
(select l.department, acad_position, no_of_hours from lecturers l inner join modules m on l.lecturer_id=m.lecturer_id)
select department, doctor, master, [full profesor] -- bez l. najpierw wybieramy tabele, potem pivotowane tabele, full  w [] bo ma spajce  
from pd
pivot 
(sum(no_of_hours) for acad_position in (doctor, master, [full profesor])) piv



------------------------------------------------------

declare @cols as nvarchar(max)=''
declare @query as nvarchar(max)=''

select @cols=@cols+QUOTENAME(module_name)+',' from 
(select distinct module_name from modules m inner join student_grades s 
on m.module_id=s.module_id where module_name like 'c%') tmp
set @cols = SUBSTRING(@cols, 1, LEN(@cols)-1) 

set @query=
'select * from
(select grade, module_name, student_id from modules m inner join student_grades s on m.module_id=s.module_id) as p
pivot (count(student_id) for module_name in('
+@cols+')) piv'

execute(@query)