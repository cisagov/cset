import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { KeyReportComponent } from '../../assessment/results/reports/key-report/key-report.component';
import { AllAnsweredquestionsComponent } from '../../reports/all-answeredquestions/all-answeredquestions.component';
import { AllCommentsmarkedComponent } from '../../reports/all-commentsmarked/all-commentsmarked.component';
import { AllReviewedComponent } from '../../reports/all-reviewed/all-reviewed.component';
import { C2m2ReportComponent } from '../../reports/c2m2/c2m2-report/c2m2-report.component';
import { CisCommentsmarkedComponent } from '../../reports/cis-commentsmarked/cis-commentsmarked.component';
import { CisRankedDeficiencyComponent } from '../../reports/cis/cis-ranked-deficiency/cis-ranked-deficiency.component';
import { CisSectionScoringComponent } from '../../reports/cis/cis-section-scoring/cis-section-scoring.component';
import { CisSurveyComponent } from '../../reports/cis/cis-survey/cis-survey.component';
import { CommentsMfrComponent } from '../../reports/commentsmfr/commentsmfr.component';
import { CompareReportMComponent } from '../../reports/compare-report-m/compare-report-m.component';
import { CompareReportComponent } from '../../reports/compare-report/compare-report.component';
import { CpgDeficiencyComponent } from '../../reports/cpg/cpg-deficiency/cpg-deficiency.component';
import { CpgReportComponent } from '../../reports/cpg/cpg-report/cpg-report.component';
import { CreFinalReportComponent } from '../../reports/crePlus/cre-final-report/cre-final-report.component';
import { CreAssessmentOverview } from '../../reports/crePlus/cre-assessment-overview/cre-assessment-overview.component';
import { CreModelChartsComponent } from '../../reports/crePlus/cre-model-charts/cre-model-charts.component';
import { CrrCommentsMarkedComponent } from '../../reports/crr/crr-comments-marked/crr-comments-marked.component';
import { CrrDeficiencyComponent } from '../../reports/crr/crr-deficiency/crr-deficiency.component';
import { CrrReportComponent } from '../../reports/crr/crr-report/crr-report.component';
import { EdmCommentsmarkedComponent } from '../../reports/edm-commentsmarked/edm-commentsmarked.component';
import { EdmDeficiencyComponent } from '../../reports/edm-deficiency/edm-deficiency.component';
import { ExecutiveSummaryComponent } from '../../reports/executive-summary/executive-summary.component';
import { GeneralDeficiencyComponent } from '../../reports/general-deficiency/general-deficiency.component';
import { HydroActionItemsReportComponent } from '../../reports/hydro/hydro-action-items-report/hydro-action-items-report.component';
import { HydroReportComponent } from '../../reports/hydro/hydro-report/hydro-report.component';
import { ImrReportComponent } from '../../reports/imr/imr-report/imr-report.component';
import { ModuleContentComponent } from '../../reports/module-content/module-content/module-content.component';
import { MvraReportComponent } from '../../reports/mvra/mvra-report.component';
import { ObservationTearoutsComponent } from '../../reports/observation-tearouts/observation-tearouts.component';
import { PhysicalSummaryComponent } from '../../reports/physical-summary/physical-summary.component';
import { RraDeficiencyComponent } from '../../reports/rra/rra-deficiency/rra-deficiency.component';
import { RraReportComponent } from '../../reports/rra/rra-report/rra-report.component';
import { SdOwnerCommentsMfrComponent } from '../../reports/sd-owner/sd-owner-comments/sd-owner-comments-mfr.component';
import { SdOwnerDeficiencyComponent } from '../../reports/sd-owner/sd-owner-deficiency/sd-owner-deficiency.component';
import { SdAnswerSummaryReportComponent } from '../../reports/sd/sd-answer-summary-report/sd-answer-summary-report.component';
import { SiteDetailComponent } from '../../reports/site-detail/site-detail.component';
import { SiteSummaryComponent } from '../../reports/site-summary/site-summary.component';
import { TrendReportComponent } from '../../reports/trend-report/trend-report.component';
import { TsaSdComponent } from '../../reports/tsa-sd/tsa-sd.component';
import { OpenEndedQuestionsComponent } from '../../reports/vadr/open-ended-questions/open-ended-questions.component';
import { VadrDeficiencyComponent } from '../../reports/vadr/vadr-deficiency/vadr-deficiency.component';
import { VadrReportComponent } from '../../reports/vadr/vadr-report/vadr-report.component';
import { CisaVadrReportComponent } from '../../reports/cisa-vadr/cisa-vadr-report/cisa-vadr-report.component';
import { CreHeatmapsComponent } from '../../reports/crePlus/cre-heatmaps/cre-heatmaps.component';
import { CreMilCharts2Component } from '../../reports/crePlus/cre-mil-charts-2/cre-mil-charts-2.component';


const routes: Routes = [
    { path: '', loadChildren: () => import('./cmmc-report-routing.module').then(m => m.CmmcReportRoutingModule) },
    { path: 'detail', component: SiteDetailComponent },
    { path: 'observations', component: ObservationTearoutsComponent },
    { path: 'executive', component: ExecutiveSummaryComponent },
    { path: 'securityplan', loadChildren: () => import('./securityplan-routing.module').then(m => m.SecurityPlanRoutingModule) },
    { path: 'sitesummary', component: SiteSummaryComponent },
    { path: 'physicalsummary', component: PhysicalSummaryComponent },
    { path: 'trend-report', component: TrendReportComponent },
    { path: 'compare-report', component: CompareReportComponent },
    { path: 'compare-report-m', component: CompareReportMComponent },
    { path: 'edm', loadChildren: () => import('./edm-routing.module').then(m => m.EdmRoutingModule) },
    { path: 'edmDeficiencyReport', component: EdmDeficiencyComponent },
    { path: 'genDeficiencyReport', component: GeneralDeficiencyComponent },
    { path: 'edmCommentsmarked', component: EdmCommentsmarkedComponent },
    { path: 'cisCommentsmarked', component: CisCommentsmarkedComponent },
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
    { path: 'cisaVadrReport', component: CisaVadrReportComponent },
    { path: 'mvraReport', component: MvraReportComponent },
    { path: 'cpgReport', component: CpgReportComponent },
    { path: 'cpgDeficiency', component: CpgDeficiencyComponent },
    { path: 'cre-final-report/:m', component: CreFinalReportComponent },
    { path: 'cre-assessment-overview', component: CreAssessmentOverview },
    { path: 'cre-model-chart-report/:m', component: CreModelChartsComponent },
    { path: 'cre-mil-charts-2', component: CreMilCharts2Component },
    { path: 'cre-heatmaps', component: CreHeatmapsComponent },
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
    { path: 'appkeyreport', component: KeyReportComponent },
    { path: 'allAnsweredQuestions', component: AllAnsweredquestionsComponent },
    { path: 'allMfrAndComments', component: AllCommentsmarkedComponent },
    { path: 'allReviewedQuestions', component: AllReviewedComponent }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class ReportRoutingModule { }