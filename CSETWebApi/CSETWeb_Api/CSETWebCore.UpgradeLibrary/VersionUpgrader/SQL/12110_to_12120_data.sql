/*
Run this script on:

(localdb)\INLLocalDB2022.CSETWeb12110    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.CSETWeb12120

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 12/12/2023 1:42:20 PM

*/
		
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Serializable
GO
BEGIN TRANSACTION

PRINT(N'Drop constraints from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK__HYDRO_DAT__Mat_Q__38652BE2 from [dbo].[HYDRO_DATA]')
ALTER TABLE [dbo].[HYDRO_DATA] NOCHECK CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MAT_QUESTION_ID from [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1 from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS from [dbo].[MATURITY_QUESTION_PROPS]')
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS from [dbo].[MATURITY_SUB_MODEL_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS from [dbo].[TTP_MAT_QUESTION]')
ALTER TABLE [dbo].[TTP_MAT_QUESTION] NOCHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Drop constraints from [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]

PRINT(N'Drop constraint FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT from [dbo].[FINANCIAL_REQUIREMENTS]')
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] NOCHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_NERC_RISK_RANKING_NEW_REQUIREMENT from [dbo].[NERC_RISK_RANKING]')
ALTER TABLE [dbo].[NERC_RISK_RANKING] NOCHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_Parameter_Requirements_NEW_REQUIREMENT from [dbo].[PARAMETER_REQUIREMENTS]')
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] NOCHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_LEVELS]')
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_QUESTIONS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[MATURITY_MODELS]')
ALTER TABLE [dbo].[MATURITY_MODELS] NOCHECK CONSTRAINT [FK_MATURITY_MODELS_MATURITY_LEVEL_USAGE_TYPES]

PRINT(N'Drop constraint FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS from [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK__AVAILABLE__model__6F6A7CB2 from [dbo].[AVAILABLE_MATURITY_MODELS]')
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] NOCHECK CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2]

PRINT(N'Drop constraint FK_MATURITY_LEVELS_MATURITY_MODELS from [dbo].[MATURITY_LEVELS]')
ALTER TABLE [dbo].[MATURITY_LEVELS] NOCHECK CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS from [dbo].[MODES_SETS_MATURITY_MODELS]')
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] NOCHECK CONSTRAINT [FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS]

PRINT(N'Drop constraints from [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]

PRINT(N'Drop constraint FILE_KEYWORDS_GEN_FILE_FK from [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] NOCHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Drop constraint FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_GEN_FILE from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_GEN_FILE from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_GEN_FILE from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_GEN_FILE from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_SET_FILES_GEN_FILE from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_ASSESSMENTS_GALLERY_ITEM from [dbo].[ASSESSMENTS]')
ALTER TABLE [dbo].[ASSESSMENTS] NOCHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]

PRINT(N'Drop constraint FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<p><b>Question Intent:</b></p>&#10;<p>&#10;To determine if services are identified.&#10;</p>&#10;<ul>&#10;&#9;<li>&#10;&#9;&#9;A service is a set of activities that the organization carries out in the performance of a duty or in the production of a product.&#10;&#9;</li>&#10;&#9;<li>&#10;&#9;&#9;Services can be externally or internally focused. Examples can include:&#10;&#9;</li>&#10;&#9;<ul>&#10;&#9;&#9;<li>&#10;&#9;&#9;&#9;a customer-facing website such as an online payment system&#10;&#9;&#9;</li>&#10;&#9;&#9;<li>&#10;&#9;&#9;&#9;human resources transactions&#10;&#9;&#9;</li>&#10;&#9;</ul>&#10;&#9;<li>&#10;&#9;&#9;A fundamental operational resilience objective is to focus on activities to protect and sustain the identified services and&#10;&#9;&#9;assets that most directly affect the organization''s ability to achieve its mission.&#10;&#9;&#9;</li>&#10;&#9;</ul>&#10;&#9;<p><b>&#10;&#9;&#9;Criteria for &#8220;Yes&#8221; Response:&#10;&#9;</b></p>&#10;&#10;&#9;&#9;<ul>&#10;&#9;&#9;&#9;<li>&#10;&#9;&#9;&#9;&#9;The organization has identified all services.&#10;&#9;&#9;&#9;</li>&#10;&#9;&#9;</ul>&#10;&#9;&#9;<p><b>&#10;&#9;&#9;&#9;Criteria for &#8220;Incomplete&#8221; Response:&#10;&#9;&#9;</b></p>&#10;&#9;&#9;<ul>&#10;&#9;&#9;&#9;<li>&#10;&#9;&#9;&#9;&#9;<span>&#10;&#9;&#9;&#9;&#9;&#9;The organization has identified some services.&#10;&#9;&#9;&#9;&#9;</span>&#10;&#9;&#9;&#9;</li>&#10;&#9;&#9;</ul>' WHERE [Mat_Question_Id] = 1823
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<p><b>Question Intent:</b></p>&#10;<p>To determine if services are prioritized based on analysis of the potential impact if the services are disrupted.&#10;</p>&#10;<ul class="ul1">&#10;    <li class="li1"><span class="s1"></span>The organization should conduct analysis of identified services (e.g., a&#10;        business impact analysis) to determine the impact to the organization of the loss or disruption of each service.&#10;    </li>&#10;    <li class="li1"><span class="s1"></span>The results of this analysis should then be used to prioritize the&#10;        organizational services.</li>&#10;</ul>&#10;<p><b>Typical work products:</b></p>&#10;<ul class="ul1">&#10;    <li class="li1"><span class="s1"></span>results of risk assessment and business impact analyses</li>&#10;    <li class="li1"><span class="s1"></span>prioritized list of organizational services, activities, and associated&#10;        assets</li>&#10;</ul>&#10;<div>&#10;    <p><b>Criteria for &#8220;Yes&#8221; Response:</b></p>&#10;    <div>&#10;        <ul>&#10;            <li>The organization has prioritized all services (identified in G1.Q1).</li>&#10;        </ul>&#10;    </div>&#10;    <p><b>Criteria for &#8220;Incomplete&#8221; Response:</b></p>&#10;    <div>&#10;        <ul>&#10;            <li>The organization has prioritized some services.</li>&#10;        </ul>&#10;    </div>&#10;</div>' WHERE [Mat_Question_Id] = 1824
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Is the principle of least privilege enforced through policies and procedures? ' WHERE [Mat_Question_Id] = 1917
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<p>
    <b>Question Intent: </b>To determine if the organization has a documented plan for responding to
    incidents.<br>
</p>
<p>
    Determine how much of your organization&#8217;s operations are dependent on IT. Consider how much
    your organization relies on information technology to conduct business and make it a part of your culture to
    plan for contingencies in the event of a cyber incident. Identify and prioritize your organization&#8217;s
    critical assets and the associated impacts to operations if an incident were to occur. Ask the questions that
    are necessary to understanding your security planning, operations, and security-related goals. Develop an
    understanding of how long it would take to restore normal operations. Resist the &#8220;it can&#8217;t happen
    here&#8221; pattern of thinking. Instead, focus cyber risk discussions on &#8220;what-if&#8221; scenarios and
    develop an incident response plan to prepare for various cyber events and scenarios.<br>
</p>
<p>
    Lead development of an incident response plan outlining roles and responsibilities. Test it often.
    Incident response plans and disaster recovery plans are crucial to information security, but they are separate
    plans. Incident response mainly focuses on information asset protection, while disaster recovery plans focus on
    business continuity.<br>
</p>
<p>
    Having a defined process for identifying, analyzing, responding to, and learning from incidents that
    interrupt an organization&#8217;s operations provides consistent response to cybersecurity incidents and ensures
    that objectives are met when handling an incident. Without a defined process, an organization&#8217;s incident
    response might omit actions that the organization considers important. An incident management plan describes how
    the organization will respond to cybersecurity incidents. The objective of the plan should be translated into
    specific actions assigned to individuals or groups to perform when an incident occurs.
</p>
<p>
    <b>The incident response plan should address, at a minimum:</b>
</p>

<ul>
    <li>
        the organization&#8217;s approach to incident management<br>
    </li>
    <li>
        the structure of the incident management process<br>
    </li>
    <li>
        the requirements and objectives of the incident management process<br>
    </li>
    <li>
        a description of how the organization will identify events, triage and analyze incidents,
        respond and recover from incidents, and improve its response capabilities over time<br>
    </li>
    <li>
        the roles and responsibilities (including establishing key stakeholders) necessary to carry
        out the plan<br>
    </li>
    <li>
        applicable training needs and requirements<br>
    </li>
    <li>
        resources that will be required to meet plan objectives<br>
    </li>
    <li>
        relevant costs and budgets associated with incident management activities<br>
    </li>
</ul>
<p>
    The following sections lay out the discrete steps for developing a plan that implements the incident
    management process as described above.
</p>
<p>
    <b>Possible Actions:</b> Create an Incident Response Plan
</p>

<ol>
    <li>
        Obtain support for incident management planning.
    </li>
    <li>
        Establish an event detection process.
    </li>
    <li>
        Establish a triage and analysis process.
    </li>
    <li>
        Establish an incident declaration process.
    </li>
    <li>
        Establish an incident response and recovery process.
    </li>
    <li>
        Establish an incident communications process.
    </li>
    <li>
        Establish a post-incident analysis and improvement process.
    </li>
    <li>
        Assign roles and responsibilities for incident management, including establishing appropriate
        stakeholders for escalation and resolution.
    </li>
</ol>
<p>
    <b><i>Criteria for &#8220;Yes&#8221; Response:</i></b>
</p>
<ul>
    <li>
        The organization has a documented plan for responding to incidents.
    </li>
</ul>
' WHERE [Mat_Question_Id] = 1926
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'[[Threat]] [[information]] is exchanged with [[stakeholders]] (for example, executives, operations staff, government, connected organizations, vendors, sector organizations, regulators, [[Information Sharing and Analysis Centers|Information Sharing and Analysis Centers (ISACs)]]' WHERE [Mat_Question_Id] = 2056
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'A documented [[cybersecurity]] architecture is established and maintained that includes [[Information Technology|IT]] and [[Operations Technology|OT]] systems and networks and aligns with system and asset categorization and prioritization' WHERE [Mat_Question_Id] = 2276
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'<p>
    Limit information system access to authorized users, processes acting on behalf of authorized users, or
    devices (including other information systems).
</p>

<div>
    <b>Determine if:</b>
    <ul style="list-style: none">
        <li>
            [a] authorized users are identified;
        </li>
        <li>
            [b] processes acting on behalf of authorized users are identified;
        </li>
        <li>
            [c] devices (and other systems) authorized to connect to the system are identified;

        </li>
        <li>
            [d] system access is limited to authorized users;
        </li>
        <li>
            [e] system access is limited to processes acting on behalf of authorized users; and
        </li>
        <li>
            [f] system access is limited to authorized devices (including other systems).
        </li>
    </ul>
</div>' WHERE [Mat_Question_Id] = 4785
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Periodically assess the risk to organizational operations (including mission, functions, image, or reputation), organizational assets, and individuals, resulting from the operation of organizational systems and the associated processing, storage, or transmission of CUI.<div><br></div><div><b>Determine if:</b><span class="Apple-converted-space"><b> </b><br></span>[a] the frequency to assess risk to organizational operations, organizational assets, and individuals is defined; and<span class="Apple-converted-space"> <br></span>[b] risk to organizational operations, organizational assets, and individuals resulting from the operation of an organizational system that processes, stores, or transmits CUI is assessed with the defined frequency.<span class="Apple-converted-space"> </span><br></div>', [Supplemental_Info]=N'<p><b>
        ASSESSMENT OBJECTIVES [NIST SP 800-171A]
    </b></p>
<p>
    Determine if:</p>
<ul style="list-style: none">
    <li>
        [a] the frequency to assess risk to organizational operations, organizational assets, and
        individuals is defined; and
    </li>
    <li>
        [b] risk to organizational operations, organizational assets, and individuals resulting from
        the operation of an organizational system that processes, stores, or transmits CUI is assessed with the defined
        frequency.
    </li>
</ul>

<div>
    <p><b>
            POTENTIAL ASSESSMENT METHODS AND OBJECTS [NIST SP 800-171A]
        </b>
    </p>
    <p>
        <b>
            Examine
        </b>
    </p>


    <p>
        [SELECT FROM: Risk assessment policy; security planning policy and procedures;
        procedures addressing organizational risk assessments; system security plan; risk assessment; risk assessment
        results; risk assessment reviews; risk assessment updates; other relevant documents or records].</p>


    <p>
        <b>
            Interview
        </b>
    </p>


    <p>
        [SELECT FROM: Personnel with risk assessment responsibilities; personnel with
        information security responsibilities].</p>

    <p>
        <b>
            Test
        </b>
    </p>


    <p>
        [SELECT FROM: Organizational processes for risk assessment; mechanisms supporting or for
        conducting, documenting, reviewing, disseminating, and updating the risk assessment].
    </p>
    <div>
        <p>
            <b>
                DISCUSSION [NIST SP 800-171 R2]
            </b>
        </p>


        <p>
            Clearly defined system boundaries are a prerequisite for effective risk assessments.
            Such risk assessments consider threats, vulnerabilities, likelihood, and impact to organizational
            operations, organizational assets, and individuals based on the operation and use of organizational systems.
            Risk assessments also consider risk from external parties (e.g., service providers, contractor operating
            systems on behalf of the organization, individuals accessing organizational system/n/n/n/ns, outsourcing
            entities).
            Risk assessments, either formal or informal, can be conducted at the organization level, the mission or
            business process level, or the system level, and at any phase in the system development life cycle.
        </p>


        <p>
            NIST SP 800-30 provides guidance on conducting risk assessments.
        </p>
        <p>
            <b>
                FURTHER DISCUSSION
            </b>
        </p>

        <p><i>NOTE: This section is derived from CMMC 1.02 guidance for informational purposes only. It will be
                updated when the CMMC 2.0 publications become available.</i></p>

        <p>
            Risk arises from anything that can reduce an organization''s assurance of
            mission/business success; cause harm to image or reputation; or harm individuals, other organizations,
            or the Nation.</p>



        <p>Organizations assess the risk to their operations and assets at regular
            intervals [a]. Areas where weakness or vulnerabilities could lead to risk may include:</p>

        <ul>
            <li>poorly designed and executed business processes;</li>
            <li>inadvertent actions of people, such as disclosure or modification of
                information;</li>
            <li>intentional actions of people inside and outside the organization;</li>
            <li>failure of systems to perform as intended;</li>
            <li>failures of technology; and</li>
            <li>external events, such as natural disasters, public infrastructure and
                supply chain failures.</li>
        </ul>


        <p>
            When conducting risk assessments use established criteria and procedures. The
            results of formal risk assessments are documented. It is important to note that risk assessments differ
            from vulnerability assessments (see RM.2.142). A vulnerability assessment provides input to a risk
            assessment along with other information such as results from likelihood analysis and analysis of
            potential treat sources.</p>

        <p>
            Risk assessments should be performed at defined regular intervals [a]. Mission
            risks include anything that will keep an organization from meeting its mission. Function risk is
            anything that will prevent the performance of a function. Image and reputation risks refer to intangible
            risks that have value and could cause damage to potential or future trust relationships.<span
                class="s1">63</span></p>

        <p>
            This practice, RM.2.141, which requires periodically assessing the risk to
            organization systems, assets, and individuals, is a baseline Risk Management practice. RM.2.141 enables
            several other Risk Management practices (e.g., RM.2.143 and RM.3.146), as well as CA.2.159.
        </p>

        <p>
            <b>
                Example
            </b>
        </p>

        <p>
            You are a system administrator. You and your team members are working on a big
            government contract requiring you to store CUI. As part of your periodic (e.g., annual) risk assessment
            exercise, you evaluate the new risk involved with storing CUI [a,b]. When conducting the assessment you
            consider increased legal exposure, financial requirements of safeguarding CUI, potentially elevated
            attention from external attackers, and other factors. After determining how storing CUI affects your
            overall risk profile, you use that as a basis for a conversation on how that risk should be
            mitigated. </p>

        <p>
            <b>
                Potential Assessment Considerations
            </b>
        </p>



        <span class="s1">
            <li>
        </span>Have initial and periodic risk assessments been
        conducted [b]?<span class="s2">64</span>



        <li>Are methods defined for assessing risk (e.g., reviewing security
            assessments, incident reports, and security advisories, identifying threat sources, threat events, and
            vulnerabilities, and determining likelihood, impact, and overall risk to the confidentiality of CUI)
            [b]?
            <p>
                <b>
                    KEY REFERENCES
                </b>
            </p>
            <ul>
                <li>
                    NIST SP 800-171 Rev 2 3.11.1
                </li>
                <li>NIST CSF v1.1 ID.RA-1, ID.RA-4, DE.AE-4, RS.MI-3</li>
                <li>CERT RMM v1.2 RISK:SG4</li>
                <li>NIST SP 800-53 Rev 4 RA-3</li>
            </ul>

    </div>
</div>' WHERE [Mat_Question_Id] = 4786
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Ensure that organizational systems containing CUI are protected during and after personnel actions such as terminations and transfers.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a policy and/or process for terminating system access and any credentials coincident with personnel actions is established; </div><div>[b] system access and credentials are terminated consistent with personnel actions such as termination or transfer; and </div><div>[c] the system is protected during and after personnel transfer actions. </div></div>' WHERE [Mat_Question_Id] = 4790
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Screen individuals prior to authorizing access to organizational systems containing CUI.<div><br></div><div><div><b>Determine if: </b></div><div>[a] individuals are screened prior to authorizing access to organizational systems containing CUI. </div></div>' WHERE [Mat_Question_Id] = 4791
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Enforce safeguarding measures for CUI at alternate work sites.<div><b><br></b></div><div><div><b>Determine if: </b></div><div>[a] safeguarding measures for CUI are defined for alternate work sites; and </div><div>[b] safeguarding measures for CUI are enforced for alternate work sites. </div></div>' WHERE [Mat_Question_Id] = 4792
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Protect and monitor the physical facility and support infrastructure for organizational systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the physical facility where organizational systems reside is protected; </div><div>[b] the support infrastructure for organizational systems is protected; </div><div>[c] the physical facility where organizational systems reside is monitored; and </div><div>[d] the support infrastructure for organizational systems is monitored.</div></div>' WHERE [Mat_Question_Id] = 4793
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Control and manage physical access devices.<div><b><br></b></div><div><div><b>Determine if: </b></div><div>[a] physical access devices are identified; </div><div>[b] physical access devices are controlled; and </div><div>[c] physical access devices are managed. </div></div>' WHERE [Mat_Question_Id] = 4794
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Maintain audit logs of physical access.<div><br></div><div><div><b>Determine if: </b></div><div>[a] audit logs of physical access are maintained. </div></div>' WHERE [Mat_Question_Id] = 4795
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Escort visitors and monitor visitor activity.<div><br></div><div><div><b>Determine if: </b></div><div>[a] visitors are escorted; and </div><div>[b] visitor activity is monitored. </div></div>' WHERE [Mat_Question_Id] = 4796
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Limit physical access to organizational information systems, equipment, and the respective operating environments to authorized individuals.<div><br></div><div><div><b>Determine if: </b></div><div>[a] authorized individuals allowed physical access are identified; </div><div>[b] physical access to organizational systems is limited to authorized individuals; </div><div>[c] physical access to equipment is limited to authorized individuals; and </div><div>[d] physical access to operating environments is limited to authorized individuals. </div></div>' WHERE [Mat_Question_Id] = 4797
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Implement cryptographic mechanisms to protect the confidentiality of CUI stored on digital media during transport unless otherwise protected by alternative physical safeguards.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the confidentiality of CUI stored on digital media is protected during transport using cryptographic mechanisms or alternative physical safeguards. </div></div>' WHERE [Mat_Question_Id] = 4798
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'<p>Scan for vulnerabilities in organizational systems and applications periodically and when new
    vulnerabilities affecting those systems and applications are identified.</p>
<p><b>Determine if:</b></p>
<ul style="list-style: none">
    <li>[a] the frequency to scan for vulnerabilities in organizational systems and applications is defined;</li>
    <li>[b] vulnerability scans are performed on organizational systems with the defined frequency;</li>
    <li>[c] vulnerability scans are performed on applications with the defined frequency;</li>
    <li>[d] vulnerability scans are performed on organizational systems when new vulnerabilities are identified; and
    </li>
    <li>[e] vulnerability scans are performed on applications when new vulnerabilities are identified.</li>
</ul>' WHERE [Mat_Question_Id] = 4799
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Control access to media containing CUI and maintain accountability for media during transport outside of controlled areas.<div><br></div><div><div><b>Determine if: </b></div><div>[a] access to media containing CUI is controlled; and </div><div>[b] accountability for media containing CUI is maintained during transport outside of controlled areas. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4800
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Mark media with necessary CUI markings and distribution limitations.<div><br></div><div><div><b>Determine if: </b></div><div>[a] media containing CUI is marked with applicable CUI markings; and </div><div>[b] media containing CUI is marked with distribution limitations. </div></div>' WHERE [Mat_Question_Id] = 4801
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Control the use of removable media on system components.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the use of removable media on system components is controlled. </div></div>' WHERE [Mat_Question_Id] = 4802
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Limit access to CUI on system media to authorized users.<div><br></div><div><div><b>Determine if: </b></div><div>[a] access to CUI on system media is limited to authorized users. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4803
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Protect (i.e., physically control and securely store) system media containing CUI, both paper and digital.<div><br></div><div><div><b>Determine if: </b></div><div>[a] paper media containing CUI is physically controlled; </div><div>[b] digital media containing CUI is physically controlled; </div><div>[c] paper media containing CUI is securely stored; and </div><div>[d] digital media containing CUI is securely stored. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4804
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Sanitize or destroy information system media containing Federal Contract Information before disposal or release for reuse.<div><br></div><div><div><b>Determine if: </b></div><div>[a] system media containing FCI is sanitized or destroyed before disposal; and </div><div>[b] system media containing FCI is sanitized before it is released for reuse. </div></div>' WHERE [Mat_Question_Id] = 4805
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Check media containing diagnostic and test programs for malicious code before the media are used in organizational systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] media containing diagnostic and test programs are checked for malicious code before being used in organizational systems that process, store, or transmit CUI. </div></div>' WHERE [Mat_Question_Id] = 4806
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Ensure equipment removed for off-site maintenance is sanitized of any CUI.<div><br></div><div><div><b>Determine if: </b></div><div>[a] equipment to be removed from organizational spaces for off-site maintenance is sanitized of any CUI. </div></div>' WHERE [Mat_Question_Id] = 4807
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Supervise the maintenance activities of personnel without required access authorization.<div><br></div><div><div><b>Determine if: </b></div><div>[a] maintenance personnel without required access authorization are supervised during maintenance activities. </div></div>' WHERE [Mat_Question_Id] = 4808
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Require multifactor authentication to establish nonlocal maintenance sessions via external network connections and terminate such connections when nonlocal maintenance is complete.<div><br></div><div><div><b>Determine if: </b></div><div>[a] multifactor authentication is used to establish nonlocal maintenance sessions via external network connections; and </div><div>[b] nonlocal maintenance sessions established via external network connections are terminated when nonlocal maintenance is complete. </div></div>' WHERE [Mat_Question_Id] = 4809
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Provide controls on the tools, techniques, mechanisms, and personnel used to conduct system maintenance.<div><br></div><div><div><b>Determine if: </b></div><div>[a] tools used to conduct system maintenance are controlled; </div><div>[b] techniques used to conduct system maintenance are controlled; </div><div>[c] mechanisms used to conduct system maintenance are controlled; and </div><div>[d] personnel used to conduct system maintenance are controlled. </div></div>' WHERE [Mat_Question_Id] = 4810
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Perform maintenance on organizational systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] system maintenance is performed. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4811
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Test the organizational incident response capability.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the incident response capability is tested. </div></div>' WHERE [Mat_Question_Id] = 4812
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Track, document, and report incidents to designated officials and/or authorities both internal and external to the organization.<div><br></div><div><div><b>Determine if: </b></div><div>[a] incidents are tracked; </div><div>[b] incidents are documented; </div><div>[c] authorities to whom incidents are to be reported are identified; </div><div>[d] organizational officials to whom incidents are to be reported are identified; </div><div>[e] identified authorities are notified of incidents; and </div><div>[f] identified organizational officials are notified of incidents. </div></div>' WHERE [Mat_Question_Id] = 4813
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Prohibit the use of portable storage devices when such devices have no identifiable owner.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the use of portable storage devices is prohibited when such devices have no identifiable owner. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4814
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Remediate vulnerabilities in accordance with risk assessments.<div><br></div><div><div><b>Determine if: </b></div><div>[a] vulnerabilities are identified; and </div><div>[b] vulnerabilities are remediated in accordance with risk assessments. </div></div>' WHERE [Mat_Question_Id] = 4815
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Identify unauthorized use of organizational systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] authorized use of the system is defined; and </div><div>[b] unauthorized use of the system is identified. </div></div>' WHERE [Mat_Question_Id] = 4819
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Monitor organizational systems, including inbound and outbound communications traffic, to detect attacks and indicators of potential attacks.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the system is monitored to detect attacks and indicators of potential attacks; </div><div>[b] inbound communications traffic is monitored to detect attacks and indicators of potential attacks; and </div><div>[c] outbound communications traffic is monitored to detect attacks and indicators of potential attacks. </div></div>' WHERE [Mat_Question_Id] = 4820
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Monitor system security alerts and advisories and take action in response.<div><br></div><div><div><b>Determine if: </b></div><div>[a] response actions to system security alerts and advisories are identified; </div><div>[b] system security alerts and advisories are monitored; and </div><div>[c] actions in response to system security alerts and advisories are taken. </div></div>' WHERE [Mat_Question_Id] = 4821
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Perform periodic scans of the information system and real-time scans of files from external sources as files are downloaded, opened, or executed.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the frequency for malicious code scans is defined; </div><div>[b] malicious code scans are performed with the defined frequency; and </div><div>[c] real-time malicious code scans of files from external sources as files are downloaded, opened, or executed are performed. </div></div>' WHERE [Mat_Question_Id] = 4822
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Update malicious code protection mechanisms when new releases are available.<div><br></div><div><div><b>Determine if: </b></div><div>[a] malicious code protection mechanisms are updated when new releases are available. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4823
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Provide protection from malicious code at appropriate locations within organizational information systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] designated locations for malicious code protection are identified; and </div><div>[b] protection from malicious code at designated locations is provided. </div></div>' WHERE [Mat_Question_Id] = 4824
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Identify, report, and correct information and information system flaws in a timely manner.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the time within which to identify system flaws is specified; </div><div>[b] system flaws are identified within the specified time frame; </div><div>[c] the time within which to report system flaws is specified; </div><div>[d] system flaws are reported within the specified time frame; </div><div>[e] the time within which to correct system flaws is specified; and </div><div>[f] system flaws are corrected within the specified time frame. </div></div>' WHERE [Mat_Question_Id] = 4825
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Protect the confidentiality of CUI at rest.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the confidentiality of CUI at rest is protected. </div></div>' WHERE [Mat_Question_Id] = 4828
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Protect the authenticity of communications sessions.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the authenticity of communications sessions is protected.</div></div>' WHERE [Mat_Question_Id] = 4829
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Control and monitor the use of Voice over Internet Protocol (VoIP) technologies.<div><br></div><div><div><b>Determine if: </b></div><div>[a] use of Voice over Internet Protocol (VoIP) technologies is controlled; and </div><div>[b] use of Voice over Internet Protocol (VoIP) technologies is monitored. </div></div>' WHERE [Mat_Question_Id] = 4830
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Control and monitor the use of mobile code.<div><br></div><div><div><b>Determine if: </b></div><div>[a] use of mobile code is controlled; and </div><div>[b] use of mobile code is monitored. </div></div>' WHERE [Mat_Question_Id] = 4831
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Establish and manage cryptographic keys for cryptography employed in organizational systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] cryptographic keys are established whenever cryptography is employed; and </div><div>[b] cryptographic keys are managed whenever cryptography is employed. </div></div>' WHERE [Mat_Question_Id] = 4832
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Terminate network connections associated with communications sessions at the end of the sessions or after a defined period of inactivity.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a period of inactivity to terminate network connections associated with communications sessions is defined; </div><div>[b] network connections associated with communications sessions are terminated at the end of the sessions; and </div><div>[c] network connections associated with communications sessions are terminated after the defined period of inactivity. </div></div>' WHERE [Mat_Question_Id] = 4833
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Implement cryptographic mechanisms to prevent unauthorized disclosure of CUI during transmission unless otherwise protected by alternative physical safeguards.<div><br></div><div><div><b>Determine if: </b></div><div>[a] cryptographic mechanisms intended to prevent unauthorized disclosure of CUI are identified; </div><div>[b] alternative physical safeguards intended to prevent unauthorized disclosure of CUI are identified; and </div><div>[c] either cryptographic mechanisms or alternative physical safeguards are implemented to prevent unauthorized disclosure of CUI during transmission. </div></div>' WHERE [Mat_Question_Id] = 4834
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Prevent remote devices from simultaneously establishing non-remote connections with organizational systems and communicating via some other connection to resources in external networks (i.e., split tunneling).<div><br></div><div><div><b>Determine if: </b></div><div>[a] remote devices are prevented from simultaneously establishing non-remote connections with the system and communicating via some other connection to resources in external networks (i.e., split tunneling). </div></div>' WHERE [Mat_Question_Id] = 4835
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Deny network communications traffic by default and allow network communications traffic by exception (i.e., deny all, permit by exception).<div><br></div><div><div><b>Determine if: </b></div><div>[a] network communications traffic is denied by default; and </div><div>[b] network communications traffic is allowed by exception. </div></div>' WHERE [Mat_Question_Id] = 4836
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Prevent unauthorized and unintended information transfer via shared system resources.<div><br></div><div><div><b>Determine if: </b></div><div>[a] unauthorized and unintended information transfer via shared system resources is prevented. </div></div>' WHERE [Mat_Question_Id] = 4837
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Separate user functionality from system management functionality.<div><br></div><div><div><b>Determine if: </b></div><div>[a] user functionality is identified; </div><div>[b] system management functionality is identified; and </div><div>[c] user functionality is separated from system management functionality. </div></div>' WHERE [Mat_Question_Id] = 4838
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Employ architectural designs, software development techniques, and systems engineering principles that promote effective information security within organizational systems.<div><br></div><div><div><b>Determine if:</b> </div><div>[a] architectural designs that promote effective information security are identified; </div><div>[b] software development techniques that promote effective information security are identified; </div><div>[c] systems engineering principles that promote effective information security are identified; </div><div>[d] identified architectural designs that promote effective information security are employed; </div><div>[e] identified software development techniques that promote effective information security are employed; and </div><div>[f] identified systems engineering principles that promote effective information security are employed. </div></div>' WHERE [Mat_Question_Id] = 4839
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Employ FIPS-validated cryptography when used to protect the confidentiality of CUI.<div><br></div><div><div><b>Determine if: </b></div><div>[a] FIPS-validated cryptography is employed to protect the confidentiality of CUI. </div></div>' WHERE [Mat_Question_Id] = 4840
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Prohibit remote activation of collaborative computing devices and provide indication of devices in use to users present at the device.<div><br></div><div><div><b>Determine if: </b></div><div>[a] collaborative computing devices are identified; </div><div>[b] collaborative computing devices provide indication to users of devices in use; and </div><div>[c] remote activation of collaborative computing devices is prohibited. </div></div>' WHERE [Mat_Question_Id] = 4842
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Implement subnetworks for publicly accessible system components that are physically or logically separated from internal networks.<div><br></div><div><div><b>Determine if: </b></div><div>[a] publicly accessible system components are identified; and </div><div>[b] subnetworks for publicly accessible system components are physically or logically separated from internal networks. </div></div>' WHERE [Mat_Question_Id] = 4843
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Monitor, control, and protect organizational communications (i.e., information transmitted or received by organizational information systems) at the external boundaries and key internal boundaries of the information systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the external system boundary is defined; </div><div>[b] key internal system boundaries are defined; </div><div>[c] communications are monitored at the external system boundary; </div><div>[d] communications are monitored at key internal boundaries; </div><div>[e] communications are controlled at the external system boundary; </div><div>[f] communications are controlled at key internal boundaries; </div><div>[g] communications are protected at the external system boundary; and </div><div>[h] communications are protected at key internal boundaries. </div></div>' WHERE [Mat_Question_Id] = 4844
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Provide a system capability that compares and synchronizes internal system clocks with an authoritative source to generate time stamps for audit records.<div><br></div><div><div><b>Determine if: </b></div><div>[a] internal system clocks are used to generate time stamps for audit records; </div><div>[b] an authoritative source with which to compare and synchronize internal system clocks is specified; and </div><div>[c] internal system clocks used to generate time stamps for audit records are compared to and synchronized with the specified authoritative time source. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4852
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Create and retain system audit logs and records to the extent needed to enable the monitoring, analysis, investigation, and reporting of unlawful or unauthorized system activity.<div><br></div><div><div><b>Determine if: </b></div><div>[a] audit logs needed (i.e., event types to be logged) to enable the monitoring, analysis, investigation, and reporting of unlawful or unauthorized system activity are specified; </div><div>[b] the content of audit records needed to support monitoring, analysis, investigation, and reporting of unlawful or unauthorized system activity is defined; </div><div>[c] audit records are created (generated); </div><div>[d] audit records, once created, contain the defined content; </div><div>[e] retention requirements for audit records are defined; and </div><div>[f] audit records are retained as defined. </div></div>' WHERE [Mat_Question_Id] = 4853
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Ensure that the actions of individual system users can be uniquely traced to those users so they can be held accountable for their actions.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the content of the audit records needed to support the ability to uniquely trace users to their actions is defined; and </div><div>[b] audit records, once created, contain the defined content. </div></div>' WHERE [Mat_Question_Id] = 4854
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Provide security awareness training on recognizing and reporting potential indicators of insider threat.<div><br></div><div><div><b>Determine if: </b></div><div>[a] potential indicators associated with insider threats are identified; and </div><div>[b] security awareness training on recognizing and reporting potential indicators of insider threat is provided to managers and employees. </div></div>' WHERE [Mat_Question_Id] = 4855
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Ensure that personnel are trained to carry out their assigned information security related duties and responsibilities.<div><br></div><div><div><b>Determine if: </b></div><div>[a] information security-related duties, roles, and responsibilities are defined; </div><div>[b] information security-related duties, roles, and responsibilities are assigned to designated personnel; and </div><div>[c] personnel are adequately trained to carry out their assigned information security-related duties, roles, and responsibilities. </div></div>' WHERE [Mat_Question_Id] = 4856
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Ensure that managers, system administrators, and users of organizational systems are made aware of the security risks associated with their activities and of the applicable policies, standards, and procedures related to the security of those systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] security risks associated with organizational activities involving CUI are identified; </div><div>[b] policies, standards, and procedures related to the security of the system are identified; </div><div>[c] managers, systems administrators, and users of the system are made aware of the security risks associated with their activities; and </div><div>[d] managers, systems administrators, and users of the system are made aware of the applicable policies, standards, and procedures related to the security of the system. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4857
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Encrypt CUI on mobile devices and mobile computing platforms.<div><br></div><div><div><b>Determine if: </b></div><div>[a] mobile devices and mobile computing platforms that process, store, or transmit CUI are identified; and </div><div>[b] encryption is employed to protect CUI on identified mobile devices and mobile computing platforms. </div></div>' WHERE [Mat_Question_Id] = 4859
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Authorize remote execution of privileged commands and remote access to security relevant information.<div><br></div><div><div><b>Determine if: </b></div><div>[a] privileged commands authorized for remote execution are identified; </div><div>[b] security-relevant information authorized to be accessed remotely is identified; </div><div>[c] the execution of the identified privileged commands via remote access is authorized; and </div><div>[d] access to the identified security-relevant information via remote access is authorized. </div></div>' WHERE [Mat_Question_Id] = 4860
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Control connection of mobile devices.<div><br></div><div><div><b>Determine if: </b></div><div>[a] mobile devices that process, store, or transmit CUI are identified; </div><div>[b] mobile device connections are authorized; and </div><div>[c] mobile device connections are monitored and logged. </div></div>' WHERE [Mat_Question_Id] = 4861
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Terminate (automatically) user sessions after a defined condition.<div><br></div><div><div><b>Determine if: </b></div><div>[a] conditions requiring a user session to terminate are defined; and </div><div>[b] a user session is automatically terminated after any of the defined conditions occur. </div></div>' WHERE [Mat_Question_Id] = 4862
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Prevent non-privileged users from executing privileged functions and capture the execution of such functions in audit logs.<div><br></div><div><div><b>Determine if: </b></div><div>[a] privileged functions are defined; </div><div>[b] non-privileged users are defined; </div><div>[c] non-privileged users are prevented from executing privileged functions; and </div><div>[d] the execution of privileged functions is captured in audit logs. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4863
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Separate the duties of individuals to reduce the risk of malevolent activity without collusion.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the duties of individuals requiring separation are defined; </div><div>[b] responsibilities for duties that require separation are assigned to separate individuals; and </div><div>[c] access privileges that enable individuals to exercise the duties that require separation are granted to separate individuals. </div></div>' WHERE [Mat_Question_Id] = 4864
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Employ cryptographic mechanisms to protect the confidentiality of remote access sessions.<div><br></div><div><div><b>Determine if: </b></div><div>[a] cryptographic mechanisms to protect the confidentiality of remote access sessions are identified; and </div><div>[b] cryptographic mechanisms to protect the confidentiality of remote access sessions are implemented. </div></div>' WHERE [Mat_Question_Id] = 4865
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Protect wireless access using authentication and encryption.<div><br></div><div><div><b>Determine if: </b></div><div>[a] wireless access to the system is protected using authentication; and </div><div>[b] wireless access to the system is protected using encryption. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4866
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Control the flow of CUI in accordance with approved authorizations.<div><br></div><div><div><b>Determine if: </b></div><div>[a] information flow control policies are defined; </div><div>[b] methods and enforcement mechanisms for controlling the flow of CUI are defined; </div><div>[c] designated sources and destinations (e.g., networks, individuals, and devices) for CUI within the system and between interconnected systems are identified; </div><div>[d] authorizations for controlling the flow of CUI are defined; and </div><div>[e] approved authorizations for controlling the flow of CUI are enforced. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4867
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Route remote access via managed access control points.<div><br></div><div><div><b>Determine if: </b></div><div>[a] managed access control points are identified and implemented; and </div><div>[b] remote access is routed through managed network access control points. </div></div>' WHERE [Mat_Question_Id] = 4868
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Monitor and control remote access sessions.<div><br></div><div><div><b>Determine if: </b></div><div>[a] remote access sessions are permitted; </div><div>[b] the types of permitted remote access are identified; </div><div>[c] remote access sessions are controlled; and </div><div>[d] remote access sessions are monitored. </div></div>' WHERE [Mat_Question_Id] = 4869
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Authorize wireless access prior to allowing such connections.<div><br></div><div><div><b>Determine if: </b></div><div>[a] wireless access points are identified; and </div><div>[b] wireless access is authorized prior to allowing such connections. </div></div>' WHERE [Mat_Question_Id] = 4870
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Use session lock with pattern-hiding displays to prevent access and viewing of data after a period of inactivity.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the period of inactivity after which the system initiates a session lock is defined; </div><div>[b] access to the system and viewing of data is prevented by initiating a session lock after the defined period of inactivity; and </div><div>[c] previously visible information is concealed via a pattern-hiding display after the defined period of inactivity. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4871
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Limit unsuccessful logon attempts.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the means of limiting unsuccessful logon attempts is defined; and </div><div>[b] the defined means of limiting unsuccessful logon attempts is implemented. </div></div>' WHERE [Mat_Question_Id] = 4872
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Use non-privileged accounts or roles when accessing nonsecurity functions.<div><br></div><div><div><b>Determine if:</b> </div><div>[a] nonsecurity functions are identified; and </div><div>[b] users are required to use non-privileged accounts or roles when accessing nonsecurity functions. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4873
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Employ the principle of least privilege, including for specific security functions and privileged accounts.<div><br></div><div><div><b>Determine if: </b></div><div>[a] privileged accounts are identified; </div><div>[b] access to privileged accounts is authorized in accordance with the principle of least privilege; </div><div>[c] security functions are identified; and </div><div>[d] access to security functions is authorized in accordance with the principle of least privilege. </div></div>' WHERE [Mat_Question_Id] = 4874
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Limit use of portable storage devices on external systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the use of portable storage devices containing CUI on external systems is identified and documented; </div><div>[b] limits on the use of portable storage devices containing CUI on external systems are defined; and </div><div>[c] the use of portable storage devices containing CUI on external systems is limited as defined. </div></div>' WHERE [Mat_Question_Id] = 4875
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Control information posted or processed on publicly accessible information systems.<div><br></div><div><div><b>Determine if:</b> </div><div>[a] individuals authorized to post or process information on publicly accessible systems are identified; </div><div>[b] procedures to ensure FCI is not posted or processed on publicly accessible systems are identified; </div><div>[c] a review process is in place prior to posting of any content to publicly accessible systems; </div><div>[d] content on publicly accessible systems is reviewed to ensure that it does not include FCI; and </div><div>[e] mechanisms are in place to remove and address improper posting of FCI. </div></div>' WHERE [Mat_Question_Id] = 4877
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Verify and control/limit connections to and use of external information systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] connections to external systems are identified; </div><div>[b] the use of external systems is identified; </div><div>[c] connections to external systems are verified; </div><div>[d] the use of external systems is verified; </div><div>[e] connections to external systems are controlled/limited; and </div><div>[f] the use of external systems is controlled/limited. </div></div>' WHERE [Mat_Question_Id] = 4878
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Limit information system access to the types of transactions and functions that authorized users are permitted to execute.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the types of transactions and functions that authorized users are permitted to execute are defined; and </div><div>[b] system access is limited to the defined types of transactions and functions for authorized users. </div></div>' WHERE [Mat_Question_Id] = 4879
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Review and update logged events.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a process for determining when to review logged events is defined; </div><div>[b] event types being logged are reviewed in accordance with the defined review process; and </div><div>[c] event types being logged are updated based on the review. </div></div>' WHERE [Mat_Question_Id] = 4880
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Alert in the event of an audit logging process failure.<div><br></div><div><div><b>Determine if: </b></div><div>[a] personnel or roles to be alerted in the event of an audit logging process failure are identified; </div><div>[b] types of audit logging process failures for which alert will be generated are defined; and </div><div>[c] identified personnel or roles are alerted in the event of an audit logging process failure.</div><div><br></div></div>' WHERE [Mat_Question_Id] = 4882
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Protect audit information and audit logging tools from unauthorized access, modification, and deletion.<div><br></div><div><div><b>Determine if: </b></div><div>[a] audit information is protected from unauthorized access; </div><div>[b] audit information is protected from unauthorized modification; </div><div>[c] audit information is protected from unauthorized deletion; </div><div>[d] audit logging tools are protected from unauthorized access; </div><div>[e] audit logging tools are protected from unauthorized modification; and </div><div>[f] audit logging tools are protected from unauthorized deletion. </div></div>' WHERE [Mat_Question_Id] = 4883
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Establish an operational incident-handling capability for organizational systems that includes preparation, detection, analysis, containment, recovery, and user response activities.<div><br></div><div><div><b>Determine if: </b></div><div>[a] an operational incident-handling capability is established; </div><div>[b] the operational incident-handling capability includes preparation; </div><div>[c] the operational incident-handling capability includes detection; </div><div>[d] the operational incident-handling capability includes analysis; </div><div>[e] the operational incident-handling capability includes containment; </div><div>[f] the operational incident-handling capability includes recovery; and </div><div>[g] the operational incident-handling capability includes user response activities. </div></div>' WHERE [Mat_Question_Id] = 4884
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Disable identifiers after a defined period of inactivity.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a period of inactivity after which an identifier is disabled is defined; and </div><div>[b] identifiers are disabled after the defined period of inactivity. </div></div>' WHERE [Mat_Question_Id] = 4885
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Prevent the reuse of identifiers for a defined period.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a period within which identifiers cannot be reused is defined; and </div><div>[b] reuse of identifiers is prevented within the defined period. </div></div>' WHERE [Mat_Question_Id] = 4886
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Employ replay-resistant authentication mechanisms for network access to privileged and non-privileged accounts.<div><br></div><div><div><b>Determine if: </b></div><div>[a] replay-resistant authentication mechanisms are implemented for network account access to privileged and non-privileged accounts. </div></div>' WHERE [Mat_Question_Id] = 4887
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Use multifactor authentication for local and network access to privileged accounts and for network access to nonprivileged accounts.<div><br></div><div><div><b>Determine if: </b></div><div>[a] privileged accounts are identified; </div><div>[b] multifactor authentication is implemented for local access to privileged accounts; </div><div>[c] multifactor authentication is implemented for network access to privileged accounts; and </div><div>[d] multifactor authentication is implemented for network access to non-privileged accounts. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4888
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Obscure feedback of authentication information.<div><br></div><div><div><b>Determine if: </b></div><div>[a] authentication information is obscured during the authentication process. </div></div>' WHERE [Mat_Question_Id] = 4889
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Store and transmit only cryptographically-protected passwords.<div><br></div><div><div><b>Determine if: </b></div><div>[a] passwords are cryptographically protected in storage; and </div><div>[b] passwords are cryptographically protected in transit.</div></div>' WHERE [Mat_Question_Id] = 4890
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Allow temporary password use for system logons with an immediate change to a permanent password.<div><br></div><div><div><b>Determine if: </b></div><div>[a] an immediate change to a permanent password is required when a temporary password is used for system logon. </div></div>' WHERE [Mat_Question_Id] = 4891
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Prohibit password reuse for a specified number of generations.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the number of generations during which a password cannot be reused is specified and </div><div>[b] reuse of passwords is prohibited during the specified number of generations. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4892
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Enforce a minimum password complexity and change of characters when new passwords are created.<div><br></div><div><div><b>Determine if: </b></div><div>[a] password complexity requirements are defined; </div><div>[b] password change of character requirements are defined; </div><div>[c] minimum password complexity requirements as defined are enforced when new passwords are created; and </div><div>[d] minimum password change of character requirements as defined are enforced when new passwords are created. </div><div><br></div></div>' WHERE [Mat_Question_Id] = 4893
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Authenticate (or verify) the identities of those users, processes, or devices, as a prerequisite to allowing access to organizational information systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the identity of each user is authenticated or verified as a prerequisite to system access; </div><div>[b] the identity of each process acting on behalf of a user is authenticated or verified as a prerequisite to system access; and </div><div>[c] the identity of each device accessing or connecting to the system is authenticated or verified as a prerequisite to system access. </div></div>' WHERE [Mat_Question_Id] = 4894
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Identify information system users, processes acting on behalf of users, or devices.<div><br></div><div><div><b>Determine if:</b> </div><div>[a] system users are identified; </div><div>[b] processes acting on behalf of users are identified; and </div><div>[c] devices accessing the system are identified. </div></div>' WHERE [Mat_Question_Id] = 4895
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Apply deny-by-exception (blacklisting) policy to prevent the use of unauthorized software or deny-all, permit-by-exception (whitelisting) policy to allow the execution of authorized software.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a policy specifying whether whitelisting or blacklisting is to be implemented is specified; </div><div>[b] the software allowed to execute under whitelisting or denied use under blacklisting is specified; and </div><div>[c] whitelisting to allow the execution of authorized software or blacklisting to prevent the use of unauthorized software is implemented as specified. </div></div>' WHERE [Mat_Question_Id] = 4896
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Restrict, disable, or prevent the use of nonessential programs, functions, ports, protocols, and services.<div><br></div><div><div><b>Determine if: </b></div><div>[a] essential programs are defined; </div><div>[b] the use of nonessential programs is defined; </div><div>[c] the use of nonessential programs is restricted, disabled, or prevented as defined; </div><div>[d] essential functions are defined; </div><div>[e] the use of nonessential functions is defined; </div><div>[f] the use of nonessential functions is restricted, disabled, or prevented as defined; </div><div>[g] essential ports are defined; </div><div>[h] the use of nonessential ports is defined; </div><div>[i] the use of nonessential ports is restricted, disabled, or prevented as defined; </div><div>[j] essential protocols are defined; </div><div>[k] the use of nonessential protocols is defined; </div><div>[l] the use of nonessential protocols is restricted, disabled, or prevented as defined; </div><div>[m] essential services are defined; </div><div>[n] the use of nonessential services is defined; and </div><div>[o] the use of nonessential services is restricted, disabled, or prevented as defined. </div></div>' WHERE [Mat_Question_Id] = 4897
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Define, document, approve, and enforce physical and logical access restrictions associated with changes to organizational systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] physical access restrictions associated with changes to the system are defined; </div><div>[b] physical access restrictions associated with changes to the system are documented; </div><div>[c] physical access restrictions associated with changes to the system are approved; </div><div>[d] physical access restrictions associated with changes to the system are enforced; </div><div>[e] logical access restrictions associated with changes to the system are defined; </div><div>[f] logical access restrictions associated with changes to the system are documented; </div><div>[g] logical access restrictions associated with changes to the system are approved; and </div><div>[h] logical access restrictions associated with changes to the system are enforced.</div></div>' WHERE [Mat_Question_Id] = 4898
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Analyze the security impact of changes prior to implementation.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the security impact of changes to the system is analyzed prior to implementation. </div></div>' WHERE [Mat_Question_Id] = 4899
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Track, review, approve, or disapprove, and log changes to organizational systems. <div><br></div><div><div><b>Determine if: </b></div><div>[a] changes to the system are tracked; </div><div>[b] changes to the system are reviewed; </div><div>[c] changes to the system are approved or disapproved; and </div><div>[d] changes to the system are logged. </div></div>' WHERE [Mat_Question_Id] = 4900
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Establish and enforce security configuration settings for information technology products employed in organizational systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] security configuration settings for information technology products employed in the system are established and included in the baseline configuration; and </div><div>[b] security configuration settings for information technology products employed in the system are enforced. </div></div>' WHERE [Mat_Question_Id] = 4901
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Control and monitor user installed software.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a policy for controlling the installation of software by users is established; </div><div>[b] installation of software by users is controlled based on the established policy; and </div><div>[c] installation of software by users is monitored. </div></div>' WHERE [Mat_Question_Id] = 4902
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Employ the principle of least functionality by configuring organizational systems to provide only essential capabilities.<div><br></div><div><div><b>Determine if: </b></div><div>[a] essential system capabilities are defined based on the principle of least functionality; and </div><div>[b] the system is configured to provide only the defined essential capabilities.</div></div>' WHERE [Mat_Question_Id] = 4903
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Establish and maintain baseline configurations and inventories of organizational systems (including hardware, software, firmware, and documentation) throughout the respective system development life cycles.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a baseline configuration is established; </div><div>[b] the baseline configuration includes hardware, software, firmware, and documentation; </div><div>[c] the baseline configuration is maintained (reviewed and updated) throughout the system development life cycle; </div><div>[d] a system inventory is established; </div><div>[e] the system inventory includes hardware, software, firmware, and documentation; and </div><div>[f] the inventory is maintained (reviewed and updated) throughout the system development life cycle. </div></div>' WHERE [Mat_Question_Id] = 4904
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Monitor security controls on an ongoing basis to ensure the continued effectiveness of the controls.<div><br></div><div><div><b>Determine if: </b></div><div>[a] security controls are monitored on an ongoing basis to ensure the continued effectiveness of those controls. </div></div>' WHERE [Mat_Question_Id] = 4906
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Develop and implement plans of action designed to correct deficiencies and reduce or eliminate vulnerabilities in organizational systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] deficiencies and vulnerabilities to be addressed by the plan of action are identified; </div><div>[b] a plan of action is developed to correct identified deficiencies and reduce or eliminate identified vulnerabilities; and </div><div>[c] the plan of action is implemented to correct identified deficiencies and reduce or eliminate identified vulnerabilities. </div></div>' WHERE [Mat_Question_Id] = 4907
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Periodically assess the security controls in organizational systems to determine if the controls are effective in their application.<div><br></div><div><div><b>Determine if: </b></div><div>[a] the frequency of security control assessments is defined; and </div><div>[b] security controls are assessed with the defined frequency to determine if the controls are effective in their application. </div></div>' WHERE [Mat_Question_Id] = 4908
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Develop, document, and periodically update system security plans that describe system boundaries, system environments of operation, how security requirements are implemented, and the relationships with or connections to other systems.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a system security plan is developed; </div><div>[b] the system boundary is described and documented in the system security plan; </div><div>[c] the system environment of operation is described and documented in the system security plan; </div><div>[d] the security requirements identified and approved by the designated authority as non-applicable are identified; </div><div>[e] the method of security requirement implementation is described and documented in the system security plan; </div><div>[f] the relationship with or connection to other systems is described and documented in the system security plan; </div><div>[g] the frequency to update the system security plan is defined; and [h] system security plan is updated with the defined frequency.</div></div>' WHERE [Mat_Question_Id] = 4909
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Provide audit record reduction and report generation to support on-demand analysis and reporting.<div><br></div><div><div><b>Determine if: </b></div><div>[a] an audit record reduction capability that supports on-demand analysis is provided; and </div><div>[b] a report generation capability that supports on-demand reporting is provided. </div></div>' WHERE [Mat_Question_Id] = 4910
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Correlate audit record review, analysis, and reporting processes for investigation and response to indications of unlawful, unauthorized, suspicious, or unusual activity.<div><br></div><div><div><b>Determine if: </b></div><div>[a] audit record review, analysis, and reporting processes for investigation and response to indications of unlawful, unauthorized, suspicious, or unusual activity are defined; and </div><div>[b] defined audit record review, analysis, and reporting processes are correlated. </div></div>' WHERE [Mat_Question_Id] = 4911
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Limit management of audit logging functionality to a subset of privileged users.<div><br></div><div><div><b>Determine if: </b></div><div>[a] a subset of privileged users granted access to manage audit logging functionality is defined; and </div><div>[b] management of audit logging functionality is limited to the defined subset of privileged users. </div></div>' WHERE [Mat_Question_Id] = 4912
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How do you manage software and hardware changes in your organization? ' WHERE [Mat_Question_Id] = 5219
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<p><strong>Control Objective</strong></p>
<p>Centrally manage [<em>Assignment: organization-defined controls and related processes</em>]. </p>
<p><strong>Supplemental Guidance</strong></p>

<p>Central management refers to
    organization-wide management and implementation of selected controls and processes. This includes planning,
    implementing, assessing, authorizing, and monitoring the organization-defined, centrally managed controls and
    processes. As the central management of controls is generally associated with the concept of common (inherited)
    controls, such management promotes and facilitates standardization of control implementations and management and the
    judicious use of organizational resources. </p>

<p>Centrally managed controls and processes may also meet independence requirements for assessments in support of
    initial and ongoing authorizations to operate and as part of organizational continuous monitoring. </p>

<p>
    Automated tools (e.g., security information and event management tools or enterprise security monitoring and
    management tools) can improve the accuracy, consistency, and availability of information associated with centrally
    managed controls and processes. Automation can also provide data aggregation and data correlation capabilities;
    alerting mechanisms; and dashboards to support risk-based decision-making within the organization.
</p>

<p>As part of the control selection processes, organizations determine the controls that may be suitable for
    central management based on resources and capabilities. It is not always possible to centrally manage every
    aspect of a control. </p>

<p>In such cases, the control can be treated as a hybrid control with the control managed and implemented
    centrally or at the system level. The controls and control enhancements that are candidates for full or partial
    central management include but are not limited to: AC-2(1), AC-2(2), AC-2(3), AC-2(4), AC-4(all), AC-17(1),
    AC-17(2), AC-17(3), AC-17(9), AC-18(1), AC-18(3), AC-18(4), AC-18(5), AC-19(4), AC-22, AC-23, AT-2(1), AT-2(2),
    AT-3(1), AT-3(2), AT-3(3), AT-4, AU-3, AU-6(1), AU-6(3), AU-6(5), AU-6(6), AU-6(9), AU-7(1), AU-7(2), AU-11,
    AU-13, AU-16, CA-2(1), CA-2(2), CA-2(3), CA-3(1), CA-3(2), CA-3(3), CA-7(1), CA-9, CM-2(2), CM-3(1), CM-3(4),
    CM-4, CM-6, CM-6(1), CM-7(2), CM-7(4), CM-7(5), CM-8(all), CM-9(1), CM-10, CM-11, CP-7(all), CP-8(all), SC-43,
    SI-2, SI-3, SI-4(all), SI-7, SI-8.
</p>

<p class="p1">
    Related Controls: PL-8, PM-9.
</p>' WHERE [Mat_Question_Id] = 5226
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How do you keep track of your user?  ' WHERE [Mat_Question_Id] = 5246
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How is accesses to critical equipment controlled? ' WHERE [Mat_Question_Id] = 5247
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How do you keep access up to date?  ' WHERE [Mat_Question_Id] = 5249
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How are critical assets protected? ' WHERE [Mat_Question_Id] = 5250
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'What is required for me to gain access to your facility?  ' WHERE [Mat_Question_Id] = 5252
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does your facility/plant have any public access? ' WHERE [Mat_Question_Id] = 5253
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How do you keep access devices up-to-date? ' WHERE [Mat_Question_Id] = 5254
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How are distribution and communication lines protected? ' WHERE [Mat_Question_Id] = 5255
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'What does your organization do to restrict the use of certain types of media on systems (removable and stationary)? (TAB9)' WHERE [Mat_Question_Id] = 5257
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Do you have a cyber policy?  ' WHERE [Mat_Question_Id] = 5261
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Were efforts to create a cyber policy helpful? ' WHERE [Mat_Question_Id] = 5262
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Do you have plans to update cybersecurity plan?  ' WHERE [Mat_Question_Id] = 5263
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'What positions in your organization have system security roles? ' WHERE [Mat_Question_Id] = 5264
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization have the capability to manage capacity, bandwidth, or other
redundancy to limit negative impacts?' WHERE [Mat_Question_Id] = 6230
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization have the capability to deploy storage or compute resources dynamically?</p>' WHERE [Mat_Question_Id] = 6233
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Has the organization defined its role in the supply chain and reviewed it for updates at least annually?</p>' WHERE [Mat_Question_Id] = 6237
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Are the associations between assets and the critical service they support documented and updated as needed at least annually?</p>' WHERE [Mat_Question_Id] = 6246
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Has the organization identified the data connections (data flows) between the critical service and other systems, including other critical services, to understand critical dependencies?' WHERE [Mat_Question_Id] = 6247
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Is the prioritization of assets reviewed and validated?</p>' WHERE [Mat_Question_Id] = 6248
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization conduct an impact-level prioritization of organizational systems to obtain additional granularity on system impact levels?</p>' WHERE [Mat_Question_Id] = 6260
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization require individuals accessing the system to employ organization-defined supplemental authentication techniques or mechanisms under specific organization-defined circumstances or situations?</p>' WHERE [Mat_Question_Id] = 6261
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Are multiple, distinct authentication challenges over the course of a session employed to confirm identity?</span></p>' WHERE [Mat_Question_Id] = 6262
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Are both network and host-based intrusion detection employed for the protection of the HVA/critical service?</p>' WHERE [Mat_Question_Id] = 6263
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization implement controls that monitor physical access to the system in addition to the physical access monitoring of facilities (where there is a concentration of system components, including server rooms, media storage areas, and communications centers)?</p>' WHERE [Mat_Question_Id] = 6264
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization implement security functions as a layered structure minimizing interactions between layers of the design and avoiding any dependence by lower layers on the functionality or correctness of higher layers? <b></b></p>' WHERE [Mat_Question_Id] = 6276
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization synchronize duplicate systems or system components?</p>' WHERE [Mat_Question_Id] = 6277
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization employ a penetration testing process that includes attempts to bypass or circumvent controls associated with physical access points to the facility?' WHERE [Mat_Question_Id] = 6282
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'<p class="Body-LessSpaceAfter">Does the organization require the developer of the system, system component, or system service to perform penetration testing:</p><p class="ListNumbered2CxSpFirst">a.     at a given level of rigor (breadth and depth) and</p><p class="ListNumbered2CxSpLast">b.     under organization-defined constraints?</p>' WHERE [Mat_Question_Id] = 6283
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization conduct red-team exercises to simulate attempts by adversaries in real-world conditions to compromise organizational systems in accordance with applicable rules of engagement?' WHERE [Mat_Question_Id] = 6284
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'<p class="Body-LessSpaceAfter">Does the organization disrupt and adversely affect the system or system component to validate the effectiveness of protections?</p>' WHERE [Mat_Question_Id] = 6285
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization test backup information with certain frequency to verify media reliability and information integrity?' WHERE [Mat_Question_Id] = 6286
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization:<br>(a) Allow the use of authentication factors that are different from the primary authentication factors after the number of organization-defined consecutive invalid logon attempts have been exceeded; and <div>(b) Enforce a limit of consecutive invalid logon attempts through use of the alternative factors by a user during an organization-defined time period.</div>' WHERE [Mat_Question_Id] = 6293
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization document which audit logs are to be monitored along with each log&#8217;s retention period and is that documentation reviewed at least annually?</p>' WHERE [Mat_Question_Id] = 6433
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the length of time that each identified audit log (including archives) is retained meet its documented retention requirements?' WHERE [Mat_Question_Id] = 6434
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Is the audit log repository protected from unauthorized modification or deletion?' WHERE [Mat_Question_Id] = 6435
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Is access to the audit log repository restricted to those with a business need?' WHERE [Mat_Question_Id] = 6436
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Are configuration baselines employed in the following organizational systems? (Select all that apply)' WHERE [Mat_Question_Id] = 6515
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'In a manner compliant with the most current versions of the National Institute of Standards and Technology (NIST) Digital Identity Guidelines, does the Owner/Operator: <div><br></div><div>Implement and complete a mandatory password reset of all  passwords within Information Technology systems (such as  corporate remote access and Virtual Private Networks)?</div><div><br></div><div>GUIDANCE: These actions must be consistent with industry standards, such as those in NIST Special Publication 800-63: Digital Identity Guidelines, and CISA''s Emergency Directive 21-01&#10;(December 13, 2020) (available at https://cyber.dhs.gov/ed/21-01/). <br></div>' WHERE [Mat_Question_Id] = 9976
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'<p>In a manner compliant with the most current versions of the National Institute of Standards and Technology
    (NIST) Digital Identity Guidelines, does the Owner/Operator:</p>

<p>Implement and complete a mandatory password reset(s) of all equipment within Operational
    Technology systems, including Programmable Logic Controllers?</p>

<p>PLEASE NOTE: The Owner/Operator must continue to comply with any TSA-approved
    alternative measures previously approved for systems where implementing a mandatory password reset is not
    technically feasible.
</p>

<p>GUIDANCE: These actions must be consistent with industry standards, such as those in NIST Special Publication
    800-63: Digital Identity Guidelines, and CISA''s Emergency Directive 21-01 (December 13, 2020) (available at
    https://cyber.dhs.gov/ed/21-01/).
</p>' WHERE [Mat_Question_Id] = 9977
PRINT(N'Operation applied to 155 rows out of 155')

PRINT(N'Update rows in [dbo].[MATURITY_GROUPINGS]')
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Description]=N'<p>Protecting your systems requires knowing which devices are connected to your network, which applications are in
    use, who has access to them, and the security measures in place. A cyber-ready business keeps its systems up-to-date
    and secure. These actions can support a proactive risk management culture and limit the risk of compromise.</p>
<p>Remove unsupported or unauthorized hardware and software. Supported hardware and software generally allow you to
    receive updates and patches for vulnerabilities that otherwise are not available for unauthorized and unsupported
    assets. Inventory authorized hardware and software throughout your organization. Know the physical location and user
    of the hardware to keep patching updates current. This also allows for any unauthorized hardware or software to be
    identified and removed.</p>' WHERE [Grouping_Id] = 177
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Description]=N'<p>Lead development of an incident response and disaster recovery plan outlining roles and responsibilities. Test it
    often. Incident response plans and disaster recovery plans are crucial to information security, but they are
    separate plans. Incident response mainly focuses on information asset protection, while disaster recovery plans
    focus on business continuity. Once you develop a plan, test the plan using realistic simulations (known as
    "war-gaming"), where roles and responsibilities are assigned to the people who manage cyber incident
    responses. This ensures that your plan is effective and that you have the appropriate people involved in the plan.
    Disaster recovery plans minimize recovery time by efficiently recovering critical systems.</p>
<p>Plan, prepare, and conduct drills for cyber-attacks and incidents as you would a fire or robbery. Make your reaction
    to cyber incidents or system outages an extension of your other business contingency plans. This involves having
    incident response plans and procedures, trained staff, assigned roles and responsibilities, and incident
    communications plans.</p>' WHERE [Grouping_Id] = 181
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Description]=N'For a &#34;YES&#34; response, first determine if all of the question objectives are met. If only some, but not all
objectives are met, it is advised to mark a &#34;NO&#34; response and utilize the comments, observations, and mark
for review functions for tracking purposes.' WHERE [Grouping_Id] = 1187
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Description]=N'<p>Until the Owner/Operator''s Cybersecurity Implementation Plan (as required by Section II.B. of the SD02C Security
    Directive) is approved by TSA, the Owner/Operator must apply the following cybersecurity measures, as modified by
    any TSA-approved alternative measures, and/or action plans, previously issued to the requirements in the Security
    Directive Pipeline2021-02 series.</p>
<p>The following requirements must be applied to any Information and/or Operational Technology system connected to a
    critical pipeline system or facility identified by TSA.</p>' WHERE [Grouping_Id] = 2616
PRINT(N'Operation applied to 4 rows out of 4')

PRINT(N'Update rows in [dbo].[NEW_REQUIREMENT]')
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31205
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31206
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31207
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31208
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31209
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31210
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31211
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31212
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31213
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31214
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31215
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31216
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31217
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=18 WHERE [Requirement_Id] = 31218
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31219
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31220
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31221
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31222
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31223
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31224
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31225
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31226
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31227
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31228
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31229
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=10 WHERE [Requirement_Id] = 31230
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=5 WHERE [Requirement_Id] = 31231
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=5 WHERE [Requirement_Id] = 31232
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=5 WHERE [Requirement_Id] = 31233
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=5 WHERE [Requirement_Id] = 31234
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=5 WHERE [Requirement_Id] = 31235
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=5 WHERE [Requirement_Id] = 31236
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=4 WHERE [Requirement_Id] = 31237
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=4 WHERE [Requirement_Id] = 31238
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=4 WHERE [Requirement_Id] = 31239
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=4 WHERE [Requirement_Id] = 31240
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=4 WHERE [Requirement_Id] = 31241
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=4 WHERE [Requirement_Id] = 31242
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=4 WHERE [Requirement_Id] = 31243
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=4 WHERE [Requirement_Id] = 31244
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31252
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31253
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31254
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31255
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31256
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31257
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31258
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31259
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31260
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31261
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31262
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=6 WHERE [Requirement_Id] = 31263
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=72 WHERE [Requirement_Id] = 31264
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=72 WHERE [Requirement_Id] = 31265
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=72 WHERE [Requirement_Id] = 31266
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=72 WHERE [Requirement_Id] = 31267
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=72 WHERE [Requirement_Id] = 31268
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=72 WHERE [Requirement_Id] = 31269
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=72 WHERE [Requirement_Id] = 31270
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=25 WHERE [Requirement_Id] = 31271
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=25 WHERE [Requirement_Id] = 31272
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=25 WHERE [Requirement_Id] = 31273
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=25 WHERE [Requirement_Id] = 31274
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=25 WHERE [Requirement_Id] = 31275
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=25 WHERE [Requirement_Id] = 31276
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=25 WHERE [Requirement_Id] = 31277
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=81 WHERE [Requirement_Id] = 31278
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=81 WHERE [Requirement_Id] = 31279
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=81 WHERE [Requirement_Id] = 31280
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=81 WHERE [Requirement_Id] = 31281
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=81 WHERE [Requirement_Id] = 31282
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=51 WHERE [Requirement_Id] = 31302
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=51 WHERE [Requirement_Id] = 31303
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=51 WHERE [Requirement_Id] = 31304
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=51 WHERE [Requirement_Id] = 31305
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=51 WHERE [Requirement_Id] = 31306
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=51 WHERE [Requirement_Id] = 31307
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=51 WHERE [Requirement_Id] = 31308
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=51 WHERE [Requirement_Id] = 31309
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=51 WHERE [Requirement_Id] = 31310
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31318
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31319
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31320
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31321
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31322
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31323
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31324
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31325
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31326
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31327
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31328
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31329
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31330
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=47 WHERE [Requirement_Id] = 31331
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=17 WHERE [Requirement_Id] = 31332
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=17 WHERE [Requirement_Id] = 31333
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=17 WHERE [Requirement_Id] = 31334
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=17 WHERE [Requirement_Id] = 31335
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=17 WHERE [Requirement_Id] = 31336
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=17 WHERE [Requirement_Id] = 31337
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=17 WHERE [Requirement_Id] = 31338
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=17 WHERE [Requirement_Id] = 31339
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=17 WHERE [Requirement_Id] = 31340
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=49 WHERE [Requirement_Id] = 31341
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=49 WHERE [Requirement_Id] = 31342
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=49 WHERE [Requirement_Id] = 31343
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=49 WHERE [Requirement_Id] = 31344
UPDATE [dbo].[NEW_REQUIREMENT] SET [Question_Group_Heading_Id]=49 WHERE [Requirement_Id] = 31345
PRINT(N'Operation applied to 108 rows out of 108')

PRINT(N'Update rows in [dbo].[MATURITY_MODELS]')
UPDATE [dbo].[MATURITY_MODELS] SET [Model_Name]=N'SD02 Series' WHERE [Maturity_Model_Id] = 14
UPDATE [dbo].[MATURITY_MODELS] SET [Model_Name]=N'SD02 Owner' WHERE [Maturity_Model_Id] = 16
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Update rows in [dbo].[GEN_FILE]')
UPDATE [dbo].[GEN_FILE] SET [Title]=N'LTCU 01-CU-11: Electronic Data Security Overview' WHERE [Gen_File_Id] = 6088
UPDATE [dbo].[GEN_FILE] SET [Title]=N'LTCU - 06-CU-07: IT Security Compliance Guide for Credit Unions' WHERE [Gen_File_Id] = 6092
UPDATE [dbo].[GEN_FILE] SET [Title]=N'LTCU - 01-CU-21: Diaster Recovery and Business Resumption' WHERE [Gen_File_Id] = 6095
UPDATE [dbo].[GEN_FILE] SET [Title]=N'LTCU 08-CU-01: Pandemic Planning' WHERE [Gen_File_Id] = 6097
UPDATE [dbo].[GEN_FILE] SET [Title]=N'LTCU 03-CU-14: Computer Software Patch Management' WHERE [Gen_File_Id] = 6099
UPDATE [dbo].[GEN_FILE] SET [Title]=N'LTCU 01-CU-20: Due Diligence Over Third Parties' WHERE [Gen_File_Id] = 6118
UPDATE [dbo].[GEN_FILE] SET [File_Type_Id]=31, [File_Name]=N'ACET Workbook Guide.pdf', [File_Size]=831488 WHERE [Gen_File_Id] = 7071
UPDATE [dbo].[GEN_FILE] SET [Title]=N'LTCU 23-CU-07: Cyber Incident Notification Requirements' WHERE [Gen_File_Id] = 7073
PRINT(N'Operation applied to 8 rows out of 8')

PRINT(N'Update row in [dbo].[GALLERY_ITEM]')
UPDATE [dbo].[GALLERY_ITEM] SET [Is_Visible]=0 WHERE [Gallery_Item_Guid] = '4737748d-c762-4459-bc76-393e816c6a2d'

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[HYDRO_DATA] WITH CHECK CHECK CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2]
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[TTP_MAT_QUESTION] WITH CHECK CHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Add constraints to [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH CHECK CHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] WITH CHECK CHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[NERC_RISK_RANKING] CHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] CHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[MATURITY_MODELS]')
ALTER TABLE [dbo].[MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_MODELS_MATURITY_LEVEL_USAGE_TYPES]
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2]
ALTER TABLE [dbo].[MATURITY_LEVELS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS]
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]
ALTER TABLE [dbo].[ASSESSMENTS] WITH CHECK CHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
COMMIT TRANSACTION
GO
