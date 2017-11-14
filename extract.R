library(RPostgreSQL)
# Соединяемся с базой
drv = dbDriver("PostgreSQL")
con = dbConnect(drv, dbname = "test", host = "127.0.0.1", user = "test", password = "123")

extractQuery <- "SELECT g.shname, g.gid, info.stid, p.discname, info.discid, info.semnum, info.sum FROM (    
SELECT stid, discid, semnum, sum(ktmark) FROM studmark
	WHERE stid IN (SELECT stid FROM student
		WHERE gid IN (SELECT gid FROM sgroup
			WHERE shname LIKE 'ИС-Б__')) 
	AND (semnum >=2 AND semnum <=3)
	GROUP BY stid, discid, semnum
	ORDER BY stid
) info
JOIN predmet p ON p.discid = info.discid
JOIN (select gid, stid from student) s ON s.stid=info.stid
JOIN (select gid, shname from sgroup) g ON s.gid=g.gid; "

data <- dbGetQuery(con, extractQuery)
write.csv(data, file="~/extractDataPR.csv", na="")

# Отсоединяемся от базы
dbDisconnect(con)
dbUnloadDriver(drv) 
