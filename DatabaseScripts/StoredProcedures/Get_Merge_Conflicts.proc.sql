CREATE PROCEDURE [dbo].[Get_Merge_Conflicts]
    -- At least 2 assessments are required to merge
	@id1 int, @id2 int, 

    -- Up to 10 total assessments are allowed
    @id3 int = NULL, @id4 int = NULL, @id5 int = NULL, @id6 int = NULL, 
    @id7 int = NULL, @id8 int = NULL, @id9 int = NULL, @id10 int = NULL

AS
BEGIN
	SET NOCOUNT ON;
	
EXEC FillEmptyMaturityQuestionsForAnalysis @id1
EXEC FillEmptyMaturityQuestionsForAnalysis @id2
EXEC FillEmptyMaturityQuestionsForAnalysis @id3
EXEC FillEmptyMaturityQuestionsForAnalysis @id4
EXEC FillEmptyMaturityQuestionsForAnalysis @id5
EXEC FillEmptyMaturityQuestionsForAnalysis @id6
EXEC FillEmptyMaturityQuestionsForAnalysis @id7
EXEC FillEmptyMaturityQuestionsForAnalysis @id8
EXEC FillEmptyMaturityQuestionsForAnalysis @id9
EXEC FillEmptyMaturityQuestionsForAnalysis @id10

SELECT 
    (SELECT Question_Text FROM MATURITY_QUESTIONS WHERE Mat_Question_Id = a.Question_Or_Requirement_Id) as Question_Text,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id1) as Assessment_Name1,
    (SELECT Charter FROM ASSESSMENTS WHERE Assessment_Id = @id1) as Charter_Number,
    (SELECT Assets FROM ASSESSMENTS WHERE Assessment_Id = @id1) as Asset_Amount,
    a.Assessment_Id as Assessment_id1,
    a.Question_Or_Requirement_Id as Question_Or_Requirement_Id1,
    a.Answer_Text as Answer_Text1,
    a.Comment as Comment1,
    a.Alternate_Justification as Alt_Text1, 
    
    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id2) as Assessment_Name2,
    b.Assessment_Id as Assessment_id2,
    b.Question_Or_Requirement_Id as Question_Or_Requirement_Id2, 
    b.Answer_Text as Answer_Text2,
    b.Comment as Comment2,
    b.Alternate_Justification as Alt_Text2,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id3) as Assessment_Name3,
    c.Assessment_Id as Assessment_id3,
    c.Question_Or_Requirement_Id as Question_Or_Requirement_Id3, 
    c.Answer_Text as Answer_Text3,
    c.Comment as Comment3,
    c.Alternate_Justification as Alt_Text3,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id4) as Assessment_Name4,
    d.Assessment_Id as Assessment_id4, 
    d.Question_Or_Requirement_Id as Question_Or_Requirement_Id4, 
    d.Answer_Text as Answer_Text4,
    d.Comment as Comment4,
    d.Alternate_Justification as Alt_Text4,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id5) as Assessment_Name5,
    e.Assessment_Id as Assessment_id5, 
    e.Question_Or_Requirement_Id as Question_Or_Requirement_Id5, 
    e.Answer_Text as Answer_Text5,
    e.Comment as Comment5,
    e.Alternate_Justification as Alt_Text5,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id6) as Assessment_Name6,
    f.Assessment_Id as Assessment_id6, 
    f.Question_Or_Requirement_Id as Question_Or_Requirement_Id6, 
    f.Answer_Text as Answer_Text6,
    f.Comment as Comment6,
    f.Alternate_Justification as Alt_Text6,

    g.Assessment_Id as Assessment_id7,
    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id7) as Assessment_Name7,
    g.Question_Or_Requirement_Id as Question_Or_Requirement_Id7, 
    g.Answer_Text as Answer_Text7,
    g.Comment as Comment7,
    g.Alternate_Justification as Alt_Text7,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id8) as Assessment_Name8,
    h.Assessment_Id as Assessment_id8,
    h.Question_Or_Requirement_Id as Question_Or_Requirement_Id8, 
    h.Answer_Text as Answer_Text8,
    h.Comment as Comment8,
    h.Alternate_Justification as Alt_Text8,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id9) as Assessment_Name9,
    i.Assessment_Id as Assessment_id9,
    i.Question_Or_Requirement_Id as Question_Or_Requirement_Id9, 
    i.Answer_Text as Answer_Text9,
    i.Comment as Comment9,
    i.Alternate_Justification as Alt_Text9,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id10) as Assessment_Name10,
    j.Assessment_Id as Assessment_id10,
  j.Question_Or_Requirement_Id as Question_Or_Requirement_Id10, 
    j.Answer_Text as Answer_Text10,
    j.Comment as Comment10,
    j.Alternate_Justification as Alt_Text10


FROM (SELECT * FROM ANSWER WHERE Assessment_Id = @id1) a

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id2) b 
ON (a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id) AND (a.Question_Type = b.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id3) c
ON (a.Question_Or_Requirement_Id = c.Question_Or_Requirement_Id) AND (a.Question_Type = c.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id4) d
ON (a.Question_Or_Requirement_Id = d.Question_Or_Requirement_Id) AND (a.Question_Type = d.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id5) e
ON (a.Question_Or_Requirement_Id = e.Question_Or_Requirement_Id) AND (a.Question_Type = e.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id6) f
ON (a.Question_Or_Requirement_Id = f.Question_Or_Requirement_Id) AND (a.Question_Type = f.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id7) g
ON (a.Question_Or_Requirement_Id = g.Question_Or_Requirement_Id) AND (a.Question_Type = g.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id8) h
ON (a.Question_Or_Requirement_Id = h.Question_Or_Requirement_Id) AND (a.Question_Type = h.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id9) i
ON (a.Question_Or_Requirement_Id = i.Question_Or_Requirement_Id) AND (a.Question_Type = i.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id10) j
ON (a.Question_Or_Requirement_Id = j.Question_Or_Requirement_Id) AND (a.Question_Type = j.Question_Type)

WHERE 
    -- Compare Exam 1 (a) to all other exams being merged
    ((a.Answer_Text != 'U' AND b.Answer_Text != 'U') AND (a.Answer_Text != b.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND c.Answer_Text != 'U') AND (a.Answer_Text != c.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND d.Answer_Text != 'U') AND (a.Answer_Text != d.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND e.Answer_Text != 'U') AND (a.Answer_Text != e.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (a.Answer_Text != f.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (a.Answer_Text != g.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (a.Answer_Text != h.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (a.Answer_Text != i.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (a.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 2 (b) to all other exams being merged
    ((b.Answer_Text != 'U' AND c.Answer_Text != 'U') AND (b.Answer_Text != c.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND d.Answer_Text != 'U') AND (b.Answer_Text != d.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND e.Answer_Text != 'U') AND (b.Answer_Text != e.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (b.Answer_Text != f.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (b.Answer_Text != g.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (b.Answer_Text != h.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (b.Answer_Text != i.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (b.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 3 (c)
    ((c.Answer_Text != 'U' AND d.Answer_Text != 'U') AND (c.Answer_Text != d.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND e.Answer_Text != 'U') AND (c.Answer_Text != e.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (c.Answer_Text != f.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (c.Answer_Text != g.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (c.Answer_Text != h.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (c.Answer_Text != i.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (c.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 4 (d)
    ((d.Answer_Text != 'U' AND e.Answer_Text != 'U') AND (d.Answer_Text != e.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (d.Answer_Text != f.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (d.Answer_Text != g.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (d.Answer_Text != h.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (d.Answer_Text != i.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (d.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 5 (e)
    ((e.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (e.Answer_Text != f.Answer_Text)) OR
    ((e.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (e.Answer_Text != g.Answer_Text)) OR
    ((e.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (e.Answer_Text != h.Answer_Text)) OR
    ((e.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (e.Answer_Text != i.Answer_Text)) OR
    ((e.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (e.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 6 (f)
    ((f.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (f.Answer_Text != g.Answer_Text)) OR
    ((f.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (f.Answer_Text != h.Answer_Text)) OR
    ((f.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (f.Answer_Text != i.Answer_Text)) OR
    ((f.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (f.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 7 (g)
    ((g.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (g.Answer_Text != g.Answer_Text)) OR
    ((g.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (g.Answer_Text != h.Answer_Text)) OR
    ((g.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (g.Answer_Text != i.Answer_Text)) OR
    ((g.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (g.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 8 (h)
    ((h.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (h.Answer_Text != i.Answer_Text)) OR
    ((h.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (h.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 9 (i)
    ((i.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (i.Answer_Text != j.Answer_Text))


END
