CREATE trigger [dbo].[Move_Domain_Filters_To_Normal_Form]
on [dbo].[FINANCIAL_DOMAIN_FILTERS]
	after UPDATE, INSERT, DELETE
as
--delete first
    delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 1		 
	delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 2		 
	delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 3		 
	delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 4		 
	delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 5		 
--then insert
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 1 from inserted where B = 1;
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 2 from inserted where E = 1;
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 3 from inserted where [int] = 1;
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 4 from inserted where [A] = 1;
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 5 from inserted where [inn] = 1;




