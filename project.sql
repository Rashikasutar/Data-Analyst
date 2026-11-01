create database puneripattern;
use puneripattern;

create table department(did int primary key auto_increment,
dname varchar(100) not null unique);



INSERT INTO department (dname) VALUES
('HR'),
('IT'),
('Accounts'),
('Training'),
('Administration');

create table employee(eid int primary key auto_increment,
ename varchar(100) not null,
salary decimal(10,2) not null check(salary>0),
joindate date not null,
email varchar(100) unique check(email like '%@'),
designation varchar(100) not null,
phone varchar(10)not null unique check(LENGTH(phone)>=10),
did int , foreign key(did)references department(did)
on update cascade
on delete set null);


INSERT INTO employee
(ename, salary, joindate, email, designation, phone, did)
VALUES
('Amit Sharma',45000,'2023-01-15','amit@company.com','HR Executive','9876543210',1),
('Priya Patil',55000,'2022-08-20','priya@company.com','Software Engineer','9876543211',2),
('Rahul Joshi',50000,'2023-04-10','rahul@company.com','Accountant','9876543212',3),
('Sneha Kulkarni',60000,'2021-12-05','sneha@company.com','Trainer','9876543213',4),
('Rohan Deshmukh',40000,'2024-02-01','rohan@company.com','Office Admin','9876543214',5);




create table course(cid int primary key auto_increment,
cname varchar(100) not null unique,
duration varchar(20),
fees decimal(10,2)not null
);


INSERT INTO course
(cname,duration,fees)
VALUES
('Java Full Stack','6 Months',50000),
('Python Full Stack','5 Months',45000),
('Data Science','8 Months',70000),
('Web Development','4 Months',35000),
('UI/UX Design','3 Months',30000);

select * from course;

create table trainers(tid int primary key auto_increment,
tname varchar(100)not null,
salary decimal(10,2)not null check(salary>0),
joindate date not null,
qualification varchar(100) not null,
experience int not null check(experience>0),
email varchar(100) unique check(email like '%@%'),

phone varchar(10)not null unique check(LENGTH(phone)>=10),
cid int ,constraint fk_course foreign key(cid) references course(cid)

on update cascade
on delete set null);

INSERT INTO trainers
(tname,salary,joindate,qualification,experience,email,phone,cid)
VALUES
('Sanjay Patil',70000,'2021-01-10','MCA',8,'sanjay@institute.com','9876543220',1),
('Meena Joshi',65000,'2022-03-15','M.Tech',6,'meena@institute.com','9876543221',2),
('Vikas Sharma',80000,'2020-06-01','M.Sc Data Science',10,'vikas@institute.com','9876543222',3),
('Neha Kulkarni',60000,'2023-02-18','B.E.',5,'neha@institute.com','9876543223',4),
('Ajay More',55000,'2023-09-01','MBA',4,'ajay@institute.com','9876543224',5);

select * from trainers;


SHOW CREATE TABLE trainers;
ALTER TABLE trainers
DROP CHECK trainers_chk_3;

ALTER TABLE trainers
ADD CONSTRAINT chk_trainers_email
CHECK (email LIKE '%@%');



create table student(sid int primary key auto_increment,
sname varchar(100) not null,
cid int ,
tid int,
email varchar(100) unique check(email like '%@'),
phone varchar(10)not null unique check(LENGTH(phone)>=10),
dob date not null,
address text not null,
gender enum('M','F','other')not null,
admission_date date not null,
foreign key (cid)references course(cid),
foreign key(tid)references trainers(tid));


INSERT INTO student
(sname,cid,tid,email,phone,dob,address,gender,admission_date)
VALUES
('Rahul Patil',1,1,'rahul@student.com','9876543230','2002-05-12','Pune','M','2024-01-15'),
('Pooja Sharma',2,2,'pooja@student.com','9876543231','2001-08-20','Mumbai','F','2024-02-01'),
('Aakash More',3,3,'aakash@student.com','9876543232','2000-11-18','Nashik','M','2024-01-20'),
('Snehal Jadhav',4,4,'snehal@student.com','9876543233','2003-03-25','Nagpur','F','2024-03-01'),
('Riya Patil',5,5,'riya@student.com','9876543234','2002-09-15','Kolhapur','F','2024-02-10');

SHOW CREATE TABLE student;
ALTER TABLE student
DROP CHECK student_chk_1;

ALTER TABLE student
ADD CONSTRAINT chk_student_email
CHECK (email LIKE '%@%');


create table subject(subid int primary key auto_increment,
subname varchar(100)not null,
cid int,
constraint fk_subject_course foreign key (cid) references course(cid)
on update cascade
on delete cascade
);

INSERT INTO subject
(subname,cid)
VALUES
('Core Java',1),
('Python Basics',2),
('Machine Learning',3),
('HTML & CSS',4),
('Figma Design',5);

create table attendance(attid int primary key auto_increment,
sid int not null,
subid int not null ,
att_date date not null,
status enum('Present','Absent','Leave'),
foreign key(sid)references student(sid),
foreign key(subid) references subject(subid)
on update cascade
on delete cascade);


INSERT INTO attendance
(sid,subid,att_date,status)
VALUES
(1,1,'2024-04-01','Present'),
(2,2,'2024-04-01','Absent'),
(3,3,'2024-04-01','Present'),
(4,4,'2024-04-01','Leave'),
(5,5,'2024-04-01','Present');


create table exam(examid int primary key auto_increment,
subid int not null ,
exam_date date not null,
exam_type enum('Midterm','Quiz','Final','Assignment')not null,
max_marks int not null check(max_marks>0),
foreign key(subid)references subject(subid)
on update cascade
on delete cascade);

INSERT INTO exam
(subid,exam_date,exam_type,max_marks)
VALUES
(1,'2024-05-10','Midterm',100),
(2,'2024-05-12','Quiz',50),
(3,'2024-05-15','Final',100),
(4,'2024-05-18','Assignment',30),
(5,'2024-05-20','Midterm',100);

show tables;

select t.tname,t.salary as trainers_salary,e.enamee.salary as 
emp_salry from trainers t cross join employees e;


-- show exam schedules with course names
select e.exam_date ,c.cname from exam e
join subject s on e.subid=s.subid
join course c on s.cid=c.cid;

select e.examid, e.exam_date,e.exam_type,c.cname from exam e
join subject s on e.subid=s.subid join course c on s.cid=c.cid;

select * from exam join subject on exam.subid= subject.subid
join course on subject.cid =course.cid;

-- total marks of each student in all exam 

select s.sname,sum(r.marks_obtained) from result r join
student s on s.sid=r.sid group by s.sname;

-- find student whose less than 3 absence

select s.sname ,count(*) as absence from attendane a join 
student s on a.sid=s.sid where a.status="Absent"
group by s.sname having count(*)<3;

-- student who haven't paid any fees
select s.sid ,s.sname ,f.sid from student s left 
join fees f on s.sid= f.sid where f.sid is null;

select d.did from department d left join employees e on d.did =e.did
where e.did is not null;

-- student attendanec details with subject name 

select s.sname,sub.subname,a.att_date ,a.status from
attendance a join student s on a.sid =s.sid
join subject sub on a.subid=sub.subid;

-- student with perfect 100% attendance
select s.sid,s.sname from student s join attendance a on s.sid=a.sid
group by s.sid,s.sname having 
sum(a.status="present")=count(*);


-- student with the most exam

select s.sname,count(r.examid) as exam_count from result r join student  s 

group by s.sname order by exam_count desc;



create table fees(feeid int primary key,
sid int not null,
amount_paid float8 not null check(amount_paid>0),
payment_date date not null,
mode enum('Cash','Card','Online','Upi')not null,
foreign key(sid)references student(sid)
on update cascade
on delete cascade);


INSERT INTO fees
(feeid,sid,amount_paid,payment_date,mode)
VALUES
(1,1,25000,'2024-01-15','Online'),
(2,2,20000,'2024-02-01','Cash'),
(3,3,35000,'2024-01-20','Card'),
(4,4,15000,'2024-03-01','Upi'),
(5,5,18000,'2024-02-10','Online');

create table result(
resultid int primary key,
sid int,
examid int,
marks_obtained int,
grade char(2)
check (grade in('A','B','C','D','F')),
foreign key (sid) references student (sid),
foreign key (examid) references exam(examid),
check(marks_obtained>=0)
);


INSERT INTO result
(resultid,sid,examid,marks_obtained,grade)
VALUES
(1,1,1,85,'A'),
(2,2,2,42,'B'),
(3,3,3,91,'A'),
(4,4,4,25,'C'),
(5,5,5,70,'B');


-- find the highest salary among all employee
select max(salary) from employee;

-- count how many employees work in each department
select d.dname,count(e.eid) from department as d left join
employees as e on d.did =e.did
group  by d.dname;

-- list employees who joined after 2022
select * from employees where year(joindate)>2022;

-- find total salary paid in each department
select d.dname,sum(e.salary)from department as d
join employees as e on d.did=e.did group by d.name;


-- show tranier name with their course name 
select tname,cname from trainers as t join course as c on t.cid=c.cid;


-- count number of student under each trainers
select t.tname ,count (s.sid)from student as s right join trainers as t on 
t.tid=s.tid group by tname;

select * from trainers;
select * from course;

-- find course that have more than 1 tranier
select c.cname,count(t.tid)from course as c join trainers as t on c.cid=t.cid
group by c.cname having count(t.tid)>1;

select c.cname,count(t.tid)from course as c join trainers as t on c.cid=t.cid
group by c.cname having count(t.tid)>1;

-- show student whose admission_date is in 2023
select sname,admission_date from student where year(admission_date)=2023;

-- list student under each course
select c.cname ,s.subname from course 	as c join
subject as s on c.cid=s.cid order by c.cname;

-- find student age 21 or above
alter table student add column age int;

update student set age= datediff(curdate(),dob)/365;

select sname,age from student where age>=21;

set sql_safe_updates=0;

select * from student;

select sname,dob, timestampdiff(year,dob,curdate()) from student
where timestampdiff(year,dob,curdate())>=21;


-- attendance table
