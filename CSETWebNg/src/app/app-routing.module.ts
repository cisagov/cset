////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AssessmentComponent } from './assessment/assessment.component';
import { AssessmentInfoComponent } from './assessment/prepare/assessment-info/assessment-info.component';
import { Assessment2InfoComponent } from './assessment/prepare/assessment-info/assessment2-info/assessment2-info.component';
import { AssessmentInfoTsaComponent } from './assessment/prepare/assessment-info/assessment-info-tsa/assessment-info-tsa.component';
import { AssessmentInfoNcuaComponent } from './assessment/prepare/assessment-info/assessment-info-ncua/assessment-info-ncua.component';
import { FrameworkComponent } from './assessment/prepare/framework/framework.component';
import { RequiredDocsComponent } from './assessment/prepare/required/required.component';
import { IRPComponent } from './assessment/prepare/irp/irp.component';
import { PrepareComponent } from './assessment/prepare/prepare.component';
import { SalsComponent } from './assessment/prepare/sals/sals.component';
import { StandardsComponent } from './assessment/prepare/standards/standards.component';
import { QuestionsComponent } from './assessment/questions/questions.component';
import { AnalysisComponent } from './assessment/results/analysis/analysis.component';
import { ComponentsRankedComponent } from './assessment/results/analysis/components-ranked/components-ranked.component';
import { ComponentsResultsComponent } from './assessment/results/analysis/components-results/components-results.component';
import { ComponentsSummaryComponent } from './assessment/results/analysis/components-summary/components-summary.component';
import { ComponentsTypesComponent } from './assessment/results/analysis/components-types/components-types.component';
import { ComponentsWarningsComponent } from './assessment/results/analysis/components-warnings/components-warnings.component';
import { DashboardComponent } from './assessment/results/analysis/dashboard/dashboard.component';
// eslint-disable-next-line max-len
import { FeedbackComponent } from './assessment/results/feedback/feedback.component';
import { RankedQuestionsComponent } from './assessment/results/analysis/ranked-questions/ranked-questions.component';
import { StandardsRankedComponent } from './assessment/results/analysis/standards-ranked/standards-ranked.component';
import { StandardsResultsComponent } from './assessment/results/analysis/standards-results/standards-results.component';
import { StandardsSummaryComponent } from './assessment/results/analysis/standards-summary/standards-summary.component';
import { OverviewComponent } from './assessment/results/overview/overview.component';
import { ReportsComponent } from './assessment/results/reports/reports.component';
import { ResultsComponent } from './assessment/results/results.component';
import { ModuleContentLaunchComponent } from './reports/module-content/module-content-launch/module-content-launch.component';
import { ModuleContentComponent } from './reports/module-content/module-content/module-content.component';

import { AssessGuard } from './guards/assess.guard';
import { AuthGuard } from './guards/auth.guard';
import { LoginComponent } from './initial/login/login.component';
import { ResetPassComponent } from './initial/reset-pass/reset-pass.component';
import { ResourceLibraryComponent } from './resource-library/resource-library.component';
import { ImportComponent } from './import/import.component';
import { AcetDetailComponent } from './assessment/results/acet-detail/acet-detail.component';
import { AcetDashboardComponent } from './assessment/results/dashboard/acet-dashboard.component';
import { SetListComponent } from './builder/custom-set-list/custom-set-list.component';
import { CustomSetComponent } from './builder/set-detail/set-detail.component';
import { RequirementListComponent } from './builder/requirement-list/requirement-list.component';
import { QuestionListComponent } from './builder/question-list/question-list.component';
import { AddQuestionComponent } from './builder/add-question/add-question.component';
import { RequirementDetailComponent } from './builder/requirement-detail/requirement-detail.component';
import { StandardDocumentsComponent } from './builder/standard-documents/standard-documents.component';
import { RefDocumentComponent } from './builder/ref-document/ref-document.component';
import { IrpSummaryComponent } from './assessment/prepare/irp-summary/irp-summary.component';
import { DiagramComponent } from './assessment/diagram/diagram.component';
import { DiagramInfoComponent } from './assessment/diagram/diagram-info/diagram-info.component';
import { AggregationHomeComponent } from './aggregation/aggregation-home/aggregation-home.component';
import { MergeComponent } from './aggregation/merge/merge.component';
import { AliasAssessmentsComponent } from './aggregation/alias-assessments/alias-assessments.component';
import { AggregationGuard } from './guards/aggregation.guard';
import { AggregationDetailComponent } from './aggregation/aggregation-detail/aggregation-detail.component';
import { TrendAnalyticsComponent } from './aggregation/trend-analytics/trend-analytics.component';
import { CompareAnalyticsComponent } from './aggregation/compare-analytics/compare-analytics.component';
//import { AnalyticsComponent } from './assessment/results/analytics/analytics.component';
import { ReportTestComponent } from './reports/report-test/report-test.component';
import { LayoutSwitcherComponent } from './layout/layout-switcher/layout-switcher.component';
import { LayoutBlankComponent } from './layout/layout-blank/layout-blank.component';
import { SiteDetailComponent } from './reports/site-detail/site-detail.component';
import { ObservationTearoutsComponent } from './reports/observation-tearouts/observation-tearouts.component';
import { ExecutiveSummaryComponent } from './reports/executive-summary/executive-summary.component';
import { ExecutiveCMMCComponent } from './reports/cmmc/executive-cmmc/executive-cmmc.component';
import { SitesummaryCMMCComponent } from './reports/cmmc/sitesummary-cmmc/sitesummary-cmmc.component';
import { SecurityplanComponent } from './reports/securityplan/securityplan.component';
import { TrendReportComponent } from './reports/trendreport/trendreport.component';
import { CompareReportComponent } from './reports/comparereport/comparereport.component';
import { SiteSummaryComponent } from './reports/site-summary/site-summary.component';
import { ModelSelectComponent } from './assessment/prepare/maturity/model-select/model-select.component';
import { CmmcLevelsComponent } from './assessment/prepare/maturity/cmmc-levels/cmmc-levels.component';
import { MaturityQuestionsComponent } from './assessment/questions/maturity-questions/maturity-questions.component';
import { MaturityQuestionsAcetComponent } from './assessment/questions/maturity-questions/maturity-questions-acet.component';
import { MaturityQuestionsIseComponent } from './assessment/questions/maturity-questions/maturity-questions-ise.component';
import { DiagramQuestionsComponent } from './assessment/questions/diagram-questions/diagram-questions.component';
import { CmmcLevelResultsComponent } from './assessment/results/mat-cmmc/cmmc-level-results/cmmc-level-results.component';
import { CmmcGapsComponent } from './assessment/results/mat-cmmc/cmmc-gaps/cmmc-gaps.component';
import { CmmcComplianceComponent } from './assessment/results/mat-cmmc/cmmc-compliance/cmmc-compliance.component';
import { CmmcLevelDrilldownComponent } from './assessment/results/mat-cmmc/cmmc-level-drilldown/cmmc-level-drilldown.component';
import { CsiComponent } from './assessment/prepare/csi/csi.component';


import { TutorialCmmcComponent } from './assessment/prepare/maturity/tutorial-cmmc/tutorial-cmmc.component';
import { TutorialCmmc2Component } from './assessment/prepare/maturity/tutorial-cmmc2/tutorial-cmmc2.component';
import { TutorialEdmComponent } from './assessment/prepare/maturity/tutorial-edm/tutorial-edm.component';



import { AcetExecutiveComponent } from './reports/acet-executive/acet-executive.component';
import { AcetDeficencyComponent } from './reports/acet-deficency/acet-deficency.component';
import { AcetCommentsmarkedComponent } from './reports/acet-commentsmarked/acet-commentsmarked.component';
import { AcetCompensatingcontrolsComponent } from './reports/acet-compensatingcontrols/acet-compensatingcontrols.component';
import { AcetAnsweredQuestionsComponent } from './reports/acet-answeredquestions/acet-answeredquestions.component';
import { IseAnsweredQuestionsComponent } from './reports/ise-answeredquestions/ise-answeredquestions.component';
import { IseMeritComponent } from './reports/ise-merit/ise-merit.component';
import { EdmComponent } from './reports/edm/edm.component';
import { EdmDeficiencyComponent } from './reports/edm-deficiency/edm-deficiency.component';
import { EdmCommentsmarkedComponent } from './reports/edm-commentsmarked/edm-commentsmarked.component';
import { CisCommentsmarkedComponent } from './reports/cis-commentsmarked/cis-commentsmarked.component';
import { PlaceholderQuestionsComponent } from './assessment/questions/placeholder-questions/placeholder-questions.component';
import { RelationshipFormationComponent } from './assessment/results/edm/relationship-formation/relationship-formation.component';
import { RelationshipManagementComponent } from './assessment/results/edm/relationship-management/relationship-management.component';
import { ServiceProtectionComponent } from './assessment/results/edm/service-protection/service-protection.component';
import { MaturityIndicatorLevelsComponent } from './assessment/results/edm/maturity-indicator-levels/maturity-indicator-levels.component';
import { SummaryResultsComponent } from './assessment/results/edm/summary-results/summary-results.component';
import { CmmcDeficiencyComponent } from './reports/cmmc/cmmc-deficiency/cmmc-deficiency.component';
import { CmmcCommentsMarkedComponent } from './reports/cmmc/cmmc-comments-marked/cmmc-comments-marked.component';
import { CmmcAltJustificationsComponent } from './reports/cmmc/cmmc-alt-justifications/cmmc-alt-justifications.component';
import { TutorialCrrComponent } from './assessment/prepare/maturity/tutorial-crr/tutorial-crr.component';
import { CrrReportComponent } from './reports/crr/crr-report/crr-report.component';
import { CrrDeficiencyComponent } from './reports/crr/crr-deficiency/crr-deficiency.component';
import { CrrCommentsMarkedComponent } from './reports/crr/crr-comments-marked/crr-comments-marked.component';
import { AssessmentComparisonAnalyticsComponent } from './initial/assessmenet-comparison-analytics/assessment-comparison-analytics.component';

import { RraReportComponent } from './reports/rra/rra-report/rra-report.component';
import { RraDeficiencyComponent } from './reports/rra/rra-deficiency/rra-deficiency.component';
import { TutorialRraComponent } from './assessment/prepare/maturity/tutorial-rra/tutorial-rra.component';
import { RraGapsComponent } from './assessment/results/mat-rra/rra-gaps/rra-gaps.component';
import { RraLevelResultsComponent } from './assessment/results/mat-rra/rra-level-results/rra-level-results.component';
import { CommentsMfrComponent } from './reports/commentsmfr/commentsmfr.component';
import { RraSummaryAllComponent } from './assessment/results/mat-rra/rra-summary-all/rra-summary-all.component';
import { CrrResultsPage } from './assessment/results/crr/crr-results-page/crr-results-page.component';
import { CrrSummaryResultsComponent } from './assessment/results/crr/crr-summary-results/crr-summary-results.component';
import { TsaAssessmentCompleteComponent } from './assessment/results/tsa-assessment-complete/tsa-assessment-complete.component';
import { SprsScoreComponent } from './assessment/results/mat-cmmc2/sprs-score/sprs-score.component';
import { Cmmc2LevelResultsComponent } from './assessment/results/mat-cmmc2/cmmc2-level-results/cmmc2-level-results.component';
import { Cmmc2DomainResultsComponent } from './assessment/results/mat-cmmc2/cmmc2-domain-results/cmmc2-domain-results.component';
import { ExecutiveCMMC2Component } from './reports/cmmc2/executive-cmmc2/executive-cmmc2.component';
import { VadrDeficiencyComponent } from './reports/vadr/vadr-deficiency/vadr-deficiency.component';
import { AssessmentInfo2TsaComponent } from './assessment/prepare/assessment-info/assessment-info2-tsa/assessment-info2-tsa.component';
import { AssessmentConfigIodComponent } from './assessment/prepare/assessment-info/assessment-config-iod/assessment-config-iod.component';
import { AssessmentDemogIodComponent } from './assessment/prepare/assessment-info/assessment-demog-iod/assessment-demog-iod.component';
import { MaturityQuestionsNestedComponent } from './assessment/questions/maturity-questions/nested/maturity-questions-nested/maturity-questions-nested.component';
import { TutorialCisComponent } from './assessment/prepare/maturity/tutorial-cis/tutorial-cis.component';
import { VadrReportComponent } from './reports/vadr/vadr-report/vadr-report.component';
import { OpenEndedQuestionsComponent } from './reports/vadr/open-ended-questions/open-ended-questions.component';
import { CisSurveyComponent } from './reports/cis/cis-survey/cis-survey.component';
import { CisRankedDeficiencyComponent } from './reports/cis/cis-ranked-deficiency/cis-ranked-deficiency.component';
import { ConfigCisComponent } from './assessment/prepare/maturity/config-cis/config-cis.component';
import { RankedDeficiencyComponent } from './assessment/results/cis/ranked-deficiency/ranked-deficiency.component';
import { CisSectionScoringComponent } from './reports/cis/cis-section-scoring/cis-section-scoring.component';
import { SectionScoringComponent } from './assessment/results/cis/section-scoring/section-scoring.component';
import { MergeExaminationsComponent } from './assessment/merge/merge-examinations.component';
import { LandingPageTabsComponent } from './initial/landing-page-tabs/landing-page-tabs.component';
import { Cmmc2DeficiencyComponent } from './reports/cmmc2/cmmc2-deficiency/cmmc2-deficiency.component';
import { Cmmc2CommentsMarkedComponent } from './reports/cmmc2/cmmc2-comments-marked/cmmc2-comments-marked.component';
import { ExamProfileComponent } from './assessment/prepare/irp/irp-ise.component';
import { ExamProfileSummaryComponent } from './assessment/prepare/irp-summary/irp-ise-summary.component';
import { IseDonutChartComponent } from './reports/ise-donut-chart/ise-donut-chart.component';
import { PrivacyWarningComponent } from './initial/privacy-warning/privacy-warning.component';
import { PrivacyWarningRejectComponent } from './initial/privacy-warning-reject/privacy-warning-reject.component';
import { IseExaminationComponent } from './reports/ise-examination/ise-examination.component';
import { IseExaminerComponent } from './reports/ise-examiner/ise-examiner.component';
import { IseDataComponent } from './reports/ise-data/ise-data.component';
import { AnalyticsCompareComponent } from './assessment/results/analytics-compare/analytics-compare.component';
import { MvraReportComponent } from './reports/mvra/mvra-report.component';
import { MvraGapsPageComponent } from './assessment/results/mat-mvra/mvra-gaps-page/mvra-gaps-page.component';
import { MvraSummaryPageComponent } from './assessment/results/mat-mvra/mvra-summary-page/mvra-summary-page.component';
import { CpgReportComponent } from './reports/cpg/cpg-report/cpg-report.component';
import { CpgDeficiencyComponent } from './reports/cpg/cpg-deficiency/cpg-deficiency.component';
import { LogoutComponent } from './initial/logout/logout.component';
import { CpgSummaryComponent } from './assessment/results/cpg/cpg-summary/cpg-summary.component';
import { CpgPracticesComponent } from './assessment/results/cpg/cpg-practices/cpg-practices.component';
import { LoginAccessKeyComponent } from './initial/login-access-key/login-access-key.component';
import { C2m2ReportComponent } from './reports/c2m2/c2m2-report/c2m2-report.component';
import { HydroDeficiencyComponent } from './assessment/results/hydro/hydro-deficiency/hydro-deficiency.component';
import { HydroReportComponent } from './reports/hydro/hydro-report/hydro-report.component';
import { HydroImpactComponent } from './assessment/results/hydro/hydro-impact/hydro-impact.component';
import { HydroFeasibilityComponent } from './assessment/results/hydro/hydro-feasibility/hydro-feasibility.component';
import { HydroActionsComponent } from './assessment/results/hydro/hydro-actions/hydro-actions.component';
import { HydroActionItemsReportComponent } from './reports/hydro/hydro-action-items-report/hydro-action-items-report.component';
import { SdAnswerSummaryComponent } from './assessment/results/sd/sd-answer-summary/sd-answer-summary.component';
import { SdAnswerSummaryReportComponent } from './reports/sd/sd-answer-summary-report/sd-answer-summary-report.component';
import { KeyReportComponent } from './assessment/results/reports/key-report/key-report.component';
import { ImrReportComponent } from './reports/imr/imr-report/imr-report.component';
import { TutorialImrComponent } from './assessment/prepare/maturity/tutorial-imr/tutorial-imr.component';
import { TsaSdComponent } from './reports/tsa-sd/tsa-sd.component';
import { OtherRemarksComponent } from './assessment/questions/other-remarks/other-remarks.component';
import { GeneralDeficiencyComponent } from './reports/general-deficiency/general-deficiency.component';
import { QuickFactsCieComponent } from './assessment/prepare/maturity/tutorial-cie/quick-facts-cie/quick-facts-cie.component';
import { OverviewCieComponent } from './assessment/prepare/maturity/tutorial-cie/overview-cie/overview-cie.component';
import { BackgroundCieComponent } from './assessment/prepare/maturity/tutorial-cie/background-cie/background-cie.component';
import { PrinciplesCieComponent } from './assessment/prepare/maturity/tutorial-cie/principles-cie/principles-cie.component';
import { LifecycleCieComponent } from './assessment/prepare/maturity/tutorial-cie/lifecycle-cie/lifecycle-cie.component';
import { HowToUseCieComponent } from './assessment/prepare/maturity/tutorial-cie/how-to-use-cie/how-to-use-cie.component';
import { TutorialCieComponent } from './assessment/prepare/maturity/tutorial-cie/tutorial-cie.component';
import { QuestionBlockCieComponent } from './assessment/questions/question-block-cie/question-block-cie.component';
import { PrincipleSummaryComponent } from './assessment/questions/principle-summary/principle-summary.component';
import { MaturityQuestionsCieComponent } from './assessment/questions/maturity-questions/maturity-questions-cie/maturity-questions-cie.component';
import { AssessmentConfigCieComponent } from './assessment/prepare/assessment-info/assessment-config-cie/assessment-config-cie.component';
import { AssessmentDetailCieComponent } from './assessment/prepare/assessment-info/assessment-detail-cie/assessment-detail-cie.component';
import { AssessmentInfoCieComponent } from './assessment/prepare/assessment-info/assessment-info-cie/assessment-info-cie.component';
import { CieExampleComponent } from './assessment/prepare/maturity/cie-example/cie-example.component';
import { CieBackgroundComponent } from './assessment/prepare/maturity/cie-example/cie-background/cie-background.component';
import { CieAnalysisComponent } from './assessment/prepare/maturity/cie-example/cie-analysis/cie-analysis.component';
import { ApplyingCieComponent } from './assessment/prepare/maturity/cie-example/cie-analysis/applying-cie/applying-cie.component';
import { PrincipleAnalysisCieComponent } from './assessment/prepare/maturity/cie-example/cie-analysis/principle-analysis-cie/principle-analysis-cie.component';
import { CieAnalysisMatrixComponent } from './assessment/prepare/maturity/cie-example/cie-analysis-matrix/cie-analysis-matrix.component';
import { MergeCieAnalysisComponent } from './assessment/merge/merge-cie-analysis/merge-cie-analysis.component';
import { CieAllQuestionsComponent } from './reports/cie/cie-all-questions/cie-all-questions.component';
import { CiePrincipleOnlyComponent } from './reports/cie/cie-principle-only/cie-principle-only.component';
import { CiePrinciplePhaseComponent } from './reports/cie/cie-principle-phase/cie-principle-phase.component';
import { CieNotApplicableComponent } from './reports/cie/cie-not-applicable/cie-not-applicable.component';
import { SdOwnerDeficiencyComponent } from './reports/sd-owner/sd-owner-deficiency/sd-owner-deficiency.component';
import { SdOwnerCommentsMfrComponent } from './reports/sd-owner/sd-owner-comments/sd-owner-comments-mfr.component';
import { AnalyticsComponent } from './assessment/results/analytics/analytics.component';
import { CieMfrReportComponent } from './reports/cie/cie-mfr-report/cie-mfr-report.component';
import { TutorialCpgComponent } from './assessment/prepare/maturity/tutorial-cpg/tutorial-cpg.component';
import { TutorialMvraComponent } from './assessment/prepare/maturity/tutorial-mvra/tutorial-mvra.component';

const appRoutes: Routes = [

  // reports routing
  {
    path: 'report-test',
    component: LayoutSwitcherComponent,
    children: [
      { path: '', component: ReportTestComponent }
    ]
  },
  {
    path: 'home',
    component: LayoutSwitcherComponent,
    children: [
      { path: 'privacy-warning', component: PrivacyWarningComponent },
      { path: 'privacy-warning-reject', component: PrivacyWarningRejectComponent },
      { path: 'login/assessment/:id', component: LoginComponent },
      { path: 'login/:eject', component: LoginComponent },
      { path: 'login', component: LoginComponent },
      { path: 'login-access', component: LoginAccessKeyComponent },
      { path: 'logout', component: LogoutComponent },
      { path: 'reset-pass', component: ResetPassComponent },
      {
        path: 'landing-page-tabs',
        component: LandingPageTabsComponent,
        canActivate: [AuthGuard],
        canActivateChild: [AuthGuard]
      },
      { path: '', redirectTo: 'landing-page-tabs', pathMatch: 'full' },
      { path: '**', redirectTo: 'landing-page-tabs' }
    ]
  },
  {
    path: '',
    component: LayoutSwitcherComponent,
    children: [
      { path: 'compare', component: AggregationHomeComponent },
      { path: 'merge', component: MergeComponent },
      {
        path: 'trend',
        component: AggregationHomeComponent,
        children: [
          {
            path: 'alias-assessments/:id',
            component: AliasAssessmentsComponent,
            canActivate: [AggregationGuard]
          },
          { path: '', redirectTo: 'trend', pathMatch: 'full' },
          { path: '**', redirectTo: 'trend' }
        ]
      },
      { path: 'alias-assessments/:id', component: AliasAssessmentsComponent },
      { path: 'aggregation-detail/:id', component: AggregationDetailComponent },
      { path: 'compare-analytics/:id/:type', component: CompareAnalyticsComponent },
      { path: 'trend-analytics/:id', component: TrendAnalyticsComponent },

      { path: 'importModule', component: ImportComponent },

      { path: 'module-content-launch', component: ModuleContentLaunchComponent },

      { path: 'set-list', component: SetListComponent },
      {
        path: 'set-detail/:id',
        component: CustomSetComponent
      },
      {
        path: 'standard-documents/:id',
        component: StandardDocumentsComponent
      },
      {
        path: 'ref-document/:id',
        component: RefDocumentComponent
      },
      {
        path: 'requirement-list/:id',
        component: RequirementListComponent
      },
      {
        path: 'requirement-detail/:id',
        component: RequirementDetailComponent
      },
      {
        path: 'question-list/:id',
        component: QuestionListComponent
      },
      {
        path: 'add-question/:id',
        component: AddQuestionComponent
      },
      {
        path: 'assessment-comparison-analytics',
        component: AssessmentComparisonAnalyticsComponent
      },
      {
        path: 'resource-library',
        component: ResourceLibraryComponent
      },
      {
        path: 'examination-merge',
        component: MergeExaminationsComponent
      },
      {
        path: 'merge-cie-analysis',
        component: MergeCieAnalysisComponent
      },

      {
        path: 'assessment/:id',
        component: AssessmentComponent,
        canActivate: [AssessGuard],
        canActivateChild: [AssessGuard],
        children: [
          {
            path: 'prepare',
            component: PrepareComponent,
            canActivate: [AssessGuard],
            canActivateChild: [AssessGuard],
            children: [
              { path: 'info1', component: AssessmentInfoComponent },
              { path: 'info2', component: Assessment2InfoComponent },
              { path: 'info-tsa', component: AssessmentInfoTsaComponent },
              { path: 'info2-tsa', component: AssessmentInfo2TsaComponent },
              { path: 'info-demog-iod', component: AssessmentDemogIodComponent },
              { path: 'info-config-iod', component: AssessmentConfigIodComponent },
              { path: 'demographics', component: AssessmentInfoNcuaComponent },
              { path: 'model-select', component: ModelSelectComponent },
              { path: 'assessment-detail-cie', component: AssessmentDetailCieComponent },
              { path: 'assessment-info-cie', component: AssessmentInfoCieComponent },
              { path: 'assessment-config-cie', component: AssessmentConfigCieComponent },
              { path: 'tutorial-cmmc', component: TutorialCmmcComponent },
              { path: 'tutorial-cmmc2', component: TutorialCmmc2Component },
              { path: 'tutorial-edm', component: TutorialEdmComponent },
              { path: 'tutorial-crr', component: TutorialCrrComponent },
              { path: 'tutorial-imr', component: TutorialImrComponent },
              { path: 'tutorial-rra', component: TutorialRraComponent },
              { path: 'tutorial-cis', component: TutorialCisComponent },
              { path: 'tutorial-cpg', component: TutorialCpgComponent },
              { path: 'tutorial-mvra', component: TutorialMvraComponent },
              {
                path: 'tutorial-cie', component: TutorialCieComponent,
                children: [
                  { path: 'quick-facts-cie', component: QuickFactsCieComponent },
                  { path: 'overview-cie', component: OverviewCieComponent },
                  { path: 'background-cie', component: BackgroundCieComponent },
                  { path: 'principles-cie', component: PrinciplesCieComponent },
                  { path: 'lifecycle-cie', component: LifecycleCieComponent },
                ]
              },
              {
                path: 'cie-example',
                component: CieExampleComponent,
                canActivate: [AssessGuard],
                canActivateChild: [AssessGuard],
                children: [
                  { path: 'cie-background', component: CieBackgroundComponent },
                  {
                    path: 'cie-analysis',
                    component: CieAnalysisComponent,
                    canActivate: [AssessGuard],
                    canActivateChild: [AssessGuard],
                    children: [
                      { path: 'applying-cie', component: ApplyingCieComponent },
                      { path: 'principle-analysis-cie/:pri', component: PrincipleAnalysisCieComponent }
                    ]
                  },
                  { path: 'cie-analysis-matrix', component: CieAnalysisMatrixComponent },
                ]
              },
              { path: 'config-cis', component: ConfigCisComponent },
              { path: 'cmmc-levels', component: CmmcLevelsComponent },
              { path: 'csi', component: CsiComponent },
              { path: 'sal', component: SalsComponent },
              { path: 'standards', component: StandardsComponent },
              { path: 'framework', component: FrameworkComponent },
              { path: 'required', component: RequiredDocsComponent },
              { path: 'irp', component: IRPComponent },
              { path: 'irp-summary', component: IrpSummaryComponent },
              { path: 'exam-profile', component: ExamProfileComponent },
              { path: 'exam-profile-summary', component: ExamProfileSummaryComponent },
              {
                path: 'diagram',
                component: DiagramComponent,
                canActivate: [AssessGuard],
                canActivateChild: [AssessGuard],
                children: [
                  { path: 'info', component: DiagramInfoComponent },
                  { path: '', redirectTo: 'info', pathMatch: 'full' },
                  { path: '**', redirectTo: 'info' }
                ]
              },
              { path: '', redirectTo: 'info1', pathMatch: 'full' },
              { path: '**', redirectTo: 'info1' }
            ]
          },
          { path: 'questions', component: QuestionsComponent },
          { path: 'placeholder-questions', component: PlaceholderQuestionsComponent },
          { path: 'maturity-questions', component: MaturityQuestionsComponent },
          { path: 'maturity-questions-acet', component: MaturityQuestionsAcetComponent },
          { path: 'maturity-questions-ise', component: MaturityQuestionsIseComponent },
          { path: 'instructions-cie', component: HowToUseCieComponent },

          { path: 'maturity-questions-cie/:sec', component: MaturityQuestionsCieComponent },
          { path: 'question-block-cie/:sec', component: QuestionBlockCieComponent },
          { path: 'principle-summary/:pri', component: PrincipleSummaryComponent },
          { path: 'maturity-questions/:grp', component: MaturityQuestionsComponent },
          { path: 'maturity-questions-nested/:sec', component: MaturityQuestionsNestedComponent },
          { path: 'other-remarks', component: OtherRemarksComponent },
          { path: 'diagram-questions', component: DiagramQuestionsComponent },

          {
            path: 'results',
            component: ResultsComponent,
            canActivate: [AssessGuard],
            canActivateChild: [AssessGuard],
            children: [
              { path: 'cmmc-level-results', component: CmmcLevelResultsComponent },
              { path: 'cmmc-level-drilldown', component: CmmcLevelDrilldownComponent },
              { path: 'cmmc-compliance', component: CmmcComplianceComponent },
              { path: 'cmmc-gaps', component: CmmcGapsComponent },
              { path: 'sprs-score', component: SprsScoreComponent },
              { path: 'cmmc2-level-results', component: Cmmc2LevelResultsComponent },
              { path: 'cmmc2-domain-results', component: Cmmc2DomainResultsComponent },
              { path: 'rra-summary-all', component: RraSummaryAllComponent },
              { path: 'rra-level-results', component: RraLevelResultsComponent },
              { path: 'rra-gaps', component: RraGapsComponent },
              { path: 'mvra-gaps-page', component: MvraGapsPageComponent },
              { path: 'mvra-summary-page', component: MvraSummaryPageComponent },
              { path: 'cpg-summary-page', component: CpgSummaryComponent },
              { path: 'cpg-practices-page', component: CpgPracticesComponent },
              { path: 'analysis', component: AnalysisComponent },
              { path: 'dashboard', component: DashboardComponent },
              { path: 'ranked-questions', component: RankedQuestionsComponent },
              { path: 'feedback', component: FeedbackComponent },
              // { path: 'overall-ranked-categories', component: OverallRankedCategoriesComponent },
              { path: 'standards-summary', component: StandardsSummaryComponent },
              { path: 'standards-ranked', component: StandardsRankedComponent },
              { path: 'standards-results', component: StandardsResultsComponent },
              { path: 'components-summary', component: ComponentsSummaryComponent },
              { path: 'components-ranked', component: ComponentsRankedComponent },
              { path: 'components-results', component: ComponentsResultsComponent },
              { path: 'components-types', component: ComponentsTypesComponent },
              { path: 'components-warnings', component: ComponentsWarningsComponent },

              { path: 'summary-results', component: SummaryResultsComponent },
              { path: 'relationship-formation', component: RelationshipFormationComponent },
              { path: 'relationship-management', component: RelationshipManagementComponent },
              { path: 'service-protection', component: ServiceProtectionComponent },
              { path: 'maturity-indicator-levels', component: MaturityIndicatorLevelsComponent },

              { path: 'crr-summary-results', component: CrrSummaryResultsComponent },
              { path: 'crr-domain-am', component: CrrResultsPage },
              { path: 'crr-domain-cm', component: CrrResultsPage },
              { path: 'crr-domain-ccm', component: CrrResultsPage },
              { path: 'crr-domain-vm', component: CrrResultsPage },
              { path: 'crr-domain-im', component: CrrResultsPage },
              { path: 'crr-domain-scm', component: CrrResultsPage },
              { path: 'crr-domain-rm', component: CrrResultsPage },
              { path: 'crr-domain-edm', component: CrrResultsPage },
              { path: 'crr-domain-ta', component: CrrResultsPage },
              { path: 'crr-domain-sa', component: CrrResultsPage },

              { path: 'acet-detail', component: AcetDetailComponent },
              { path: 'acet-dashboard', component: AcetDashboardComponent },

              { path: 'overview', component: OverviewComponent },
              { path: 'reports', component: ReportsComponent },
              { path: 'analytics-compare', component: AnalyticsCompareComponent },
              { path: 'analytics', component: AnalyticsComponent },
              { path: 'tsa-assessment-complete', component: TsaAssessmentCompleteComponent },
              { path: 'ranked-deficiency', component: RankedDeficiencyComponent },
              { path: 'section-scoring', component: SectionScoringComponent },
              { path: '', component: DashboardComponent },
              { path: 'hydro-deficiency', component: HydroDeficiencyComponent },
              { path: 'hydro-impact', component: HydroImpactComponent },
              { path: 'hydro-feasibility', component: HydroFeasibilityComponent },
              { path: 'hydro-actions', component: HydroActionsComponent },
              { path: 'sd-answer-summary', component: SdAnswerSummaryComponent },

            ]
          },

          { path: '', redirectTo: 'prepare', pathMatch: 'full' },
          { path: '**', redirectTo: 'prepare' }
        ]
      },
      { path: '', redirectTo: '/home/landing-page-tabs', pathMatch: 'full' }
    ]
  },
  // reports routing
  {
    path: 'report', component: LayoutBlankComponent, children: [
      { path: 'detail', component: SiteDetailComponent },
      { path: 'observations', component: ObservationTearoutsComponent },
      { path: 'executive', component: ExecutiveSummaryComponent },
      { path: 'securityplan', component: SecurityplanComponent },
      { path: 'sitesummary', component: SiteSummaryComponent },
      { path: 'trendreport', component: TrendReportComponent },
      { path: 'comparereport', component: CompareReportComponent },
      { path: 'executivecmmc', component: ExecutiveCMMCComponent },
      { path: 'sitesummarycmmc', component: SitesummaryCMMCComponent },
      { path: 'cmmcDeficiencyReport', component: CmmcDeficiencyComponent },
      { path: 'cmmcCommentsMarked', component: CmmcCommentsMarkedComponent },
      { path: 'cmmcAltJustifications', component: CmmcAltJustificationsComponent },
      { path: 'cmmc2DeficiencyReport', component: Cmmc2DeficiencyComponent },
      { path: 'cmmc2CommentsMarked', component: Cmmc2CommentsMarkedComponent },
      { path: 'executivecmmc2', component: ExecutiveCMMC2Component },
      { path: 'edm', component: EdmComponent },
      { path: 'edmDeficiencyReport', component: EdmDeficiencyComponent },
      { path: 'genDeficiencyReport', component: GeneralDeficiencyComponent },
      { path: 'edmCommentsmarked', component: EdmCommentsmarkedComponent },
      { path: 'cisCommentsmarked', component: CisCommentsmarkedComponent },
      { path: 'acetexecutive', component: AcetExecutiveComponent },
      { path: 'acetgaps', component: AcetDeficencyComponent },
      { path: 'acetcommentsmarked', component: AcetCommentsmarkedComponent },
      { path: 'acetansweredquestions', component: AcetAnsweredQuestionsComponent },
      { path: 'acetcompensatingcontrols', component: AcetCompensatingcontrolsComponent },
      { path: 'iseexamination', component: IseExaminationComponent },
      { path: 'iseexaminer', component: IseExaminerComponent },
      { path: 'iseansweredquestions', component: IseAnsweredQuestionsComponent },
      { path: 'isedonutchart', component: IseDonutChartComponent },
      { path: 'isemerit', component: IseMeritComponent },
      { path: 'isedata', component: IseDataComponent },
      { path: 'cieAllQuestions', component: CieAllQuestionsComponent },
      { path: 'ciePrincipleOnly', component: CiePrincipleOnlyComponent },
      { path: 'ciePrinciplePhase', component: CiePrinciplePhaseComponent },
      { path: 'cieNotApplicable', component: CieNotApplicableComponent },
      { path: 'cieMfrReport', component: CieMfrReportComponent },
      { path: 'crrreport', component: CrrReportComponent },
      { path: 'crrDeficiencyReport', component: CrrDeficiencyComponent },
      { path: 'crrCommentsMarked', component: CrrCommentsMarkedComponent },
      { path: 'rrareport', component: RraReportComponent },
      { path: 'rraDeficiencyReport', component: RraDeficiencyComponent },
      { path: 'imrreport', component: ImrReportComponent },
      { path: 'vadrDeficiencyReport', component: VadrDeficiencyComponent },
      { path: 'vadrOpenEndedReport', component: OpenEndedQuestionsComponent },
      { path: 'cisSurveyReport', component: CisSurveyComponent },
      { path: 'cisSectionScoringReport', component: CisSectionScoringComponent },
      { path: 'cisRankedDeficiencyReport', component: CisRankedDeficiencyComponent },
      { path: 'vadrReport', component: VadrReportComponent },
      { path: 'mvraReport', component: MvraReportComponent },
      { path: 'cpgReport', component: CpgReportComponent },
      { path: 'cpgDeficiency', component: CpgDeficiencyComponent },
      { path: 'commentsmfr', component: CommentsMfrComponent },
      { path: 'module-content', component: ModuleContentComponent },
      { path: 'c2m2Report', component: C2m2ReportComponent },
      { path: 'hydroReport', component: HydroReportComponent },
      { path: 'hydroActionItemsReport', component: HydroActionItemsReportComponent },
      { path: 'sd-answer-summary', component: SdAnswerSummaryReportComponent },
      { path: 'key-report', component: KeyReportComponent },
      { path: 'sd-deficiency', component: TsaSdComponent },
      { path: 'sdo-gap-report', component: SdOwnerDeficiencyComponent },
      { path: 'sdo-comments-and-mfr', component: SdOwnerCommentsMfrComponent },
      { path: 'appkeyreport', component: KeyReportComponent }
    ]
  },
  { path: '**', redirectTo: 'home' }
];

@NgModule({
  imports: [RouterModule.forRoot(appRoutes, { enableTracing: false })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
