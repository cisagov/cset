
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getStandardsSummary] @assessment_id INT
AS
  BEGIN
      -- SET NOCOUNT ON added to prevent extra result sets from
      -- interfering with SELECT statements.
      SET nocount ON;

      /*
      TODO this needs to take into account requirements vs questions
      get the question set then for all the questions take the total risk (in this set only)
      then calculate the total risk in each question_group_heading(category) 
      then calculate the actual percentage of the total risk in each category 
      order by the total
      */
      DECLARE @applicationMode NVARCHAR(50)

      EXEC dbo.Getapplicationmodedefault
        @assessment_id,
        @ApplicationMode output

      DECLARE @maxRank INT

      IF( @ApplicationMode = 'Questions Based' )
        BEGIN
            SELECT a.answer_full_name,
                   a.short_name,
                   a.answer_text,
                   Isnull(m.qc, 0)             AS [qc],
                   Isnull(t.totalquestions, 0) AS [Total],
                   Isnull(Cast(Isnull(Round(( Cast(( Isnull(m.qc, 0) ) AS
  FLOAT) /
          ( Isnull(NULLIF(t.totalquestions, 0), 1) ) ) * 100, 0), 0)
  AS INT), 0)                 AS [Percent]
  FROM   (SELECT short_name,
          l.answer_full_name,
          l.answer_text
   FROM   available_standards a
          JOIN sets s
            ON a.set_name = s.set_name
          CROSS JOIN answer_lookup l
   WHERE  a.assessment_id = @assessment_id) a
  LEFT JOIN (
            -- Total counts subquery
            SELECT ms.short_name,
                   Count(DISTINCT c.question_id) AS TotalQuestions
             FROM   new_question c
                    JOIN new_question_sets s
                      ON c.question_id = s.question_id
                    JOIN [sets] ms
                      ON s.set_name = ms.set_name
                    JOIN available_standards v
                      ON s.set_name = v.set_name
                    JOIN new_question_levels l
                      ON s.new_question_set_id =
                         l.new_question_set_id
                    JOIN standard_selection ss
                      ON v.assessment_id = ss.assessment_id
                    JOIN universal_sal_level ul
                      ON ss.selected_sal_level = ul.full_name_sal
             WHERE  v.assessment_id = @assessment_id
                    AND v.selected = 1
                    AND l.universal_sal_level =
                        ul.universal_sal_level
             GROUP  BY ms.short_name) t
         ON a.short_name = t.short_name
  LEFT JOIN (SELECT ms.short_name,
                    a.answer_text,
                    Count(c.question_id) AS qc
             FROM   answer_questions a
                    JOIN new_question c
                      ON a.question_or_requirement_id = c.question_id
                    JOIN new_question_sets s
                      ON c.question_id = s.question_id
                    JOIN [sets] ms
                      ON s.set_name = ms.set_name
                    JOIN available_standards v
                      ON s.set_name = v.set_name
                    JOIN new_question_levels l
                      ON s.new_question_set_id =
                         l.new_question_set_id
                    JOIN standard_selection ss
                      ON v.assessment_id = ss.assessment_id
                    JOIN universal_sal_level ul
                      ON ss.selected_sal_level = ul.full_name_sal
             WHERE  a.assessment_id = @assessment_id
                    AND v.selected = 1
                    AND v.assessment_id = @assessment_id
                    AND l.universal_sal_level =
                        ul.universal_sal_level
             GROUP  BY ms.short_name,
                       a.answer_text) m
         ON a.answer_text = m.answer_text
            AND a.short_name = m.short_name
  ORDER  BY a.short_name
  END
  ELSE
  BEGIN
  SELECT a.answer_full_name,
  a.short_name,
  a.answer_text,
  Isnull(m.[qc], 0)       AS [qc],
  Isnull(t.[total], 0)    AS [Total],
  Isnull(Cast(Isnull(Round(( Cast(( Isnull(m.[qc], 0) ) AS
  FLOAT) / ( Isnull(NULLIF(t.[total], 0), 1) ) ) * 100, 0), 0)
  AS INT), 0) AS [Percent]
  FROM   (SELECT short_name,
          l.answer_full_name,
          l.answer_text
   FROM   available_standards a
          JOIN sets s
            ON a.set_name = s.set_name
          CROSS JOIN answer_lookup l
   WHERE  a.assessment_id = @assessment_id) a
  LEFT JOIN (
            -- Total requirements per Short_Name (independent of Answer_Text)
            SELECT ms.short_name,
                   Count(DISTINCT c.requirement_id) AS Total
             FROM   new_requirement c
                    JOIN requirement_sets s
                      ON c.requirement_id = s.requirement_id
                    JOIN [sets] ms
                      ON s.set_name = ms.set_name
                    JOIN available_standards v
                      ON s.set_name = v.set_name
                    JOIN requirement_levels rl
                      ON c.requirement_id = rl.requirement_id
                    JOIN standard_selection ss
                      ON v.assessment_id = ss.assessment_id
                    JOIN universal_sal_level ul
                      ON ss.selected_sal_level = ul.full_name_sal
             WHERE  v.assessment_id = @assessment_id
                    AND v.selected = 1
                    AND rl.standard_level = ul.universal_sal_level
             GROUP  BY ms.short_name) t
         ON a.short_name = t.short_name
  LEFT JOIN (
            -- Count per Short_Name and Answer_Text combination
            SELECT ms.short_name,
                   a.answer_text,
                   Count(c.requirement_id) AS qc
             FROM   answer_requirements a
                    JOIN new_requirement c
                      ON a.question_or_requirement_id =
                         c.requirement_id
                    JOIN requirement_sets s
                      ON c.requirement_id = s.requirement_id
                    JOIN [sets] ms
                      ON s.set_name = ms.set_name
                    JOIN available_standards v
                      ON s.set_name = v.set_name
                    JOIN requirement_levels rl
                      ON c.requirement_id = rl.requirement_id
                    JOIN standard_selection ss
                      ON v.assessment_id = ss.assessment_id
                    JOIN universal_sal_level ul
                      ON ss.selected_sal_level = ul.full_name_sal
             WHERE  a.assessment_id = @assessment_id
                    AND v.selected = 1
                    AND v.assessment_id = @assessment_id
                    AND rl.standard_level = ul.universal_sal_level
             GROUP  BY ms.short_name,
                       a.answer_text) m
         ON a.answer_text = m.answer_text
            AND a.short_name = m.short_name
  ORDER  BY a.short_name
  END
  END
