import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { KeyReportComponent } from '../../assessment/results/reports/key-report/key-report.component';
import { AllAnsweredquestionsComponent } from '../../assessment/results/reports/reports/all-answeredquestions/all-answeredquestions.component';
import { AllCommentsmarkedComponent } from '../../assessment/results/reports/reports/all-commentsmarked/all-commentsmarked.component';
import { AllReviewedComponent } from '../../assessment/results/reports/reports/all-reviewed/all-reviewed.component';
import { C2m2ReportComponent } from '../../assessment/results/reports/reports/c2m2/c2m2-report/c2m2-report.component';
import { CisCommentsmarkedComponent } from '../../assessment/results/reports/reports/cis-commentsmarked/cis-commentsmarked.component';
import { CisRankedDeficiencyComponent } from '../../assessment/results/reports/reports/cis/cis-ranked-deficiency/cis-ranked-deficiency.component';
import { CisSectionScoringComponent } from '../../assessment/results/reports/reports/cis/cis-section-scoring/cis-section-scoring.component';
import { CisSurveyComponent } from '../../assessment/results/reports/reports/cis/cis-survey/cis-survey.component';
import { CommentsMfrComponent } from '../../assessment/results/reports/reports/commentsmfr/commentsmfr.component';
import { CompareReportMComponent } from '../../assessment/results/reports/reports/compare-report-m/compare-report-m.component';
import { CompareReportComponent } from '../../assessment/results/reports/reports/compare-report/compare-report.component';
import { CpgDeficiencyComponent } from '../../assessment/results/reports/reports/cpg/cpg-deficiency/cpg-deficiency.component';
import { CpgReportComponent } from '../../assessment/results/reports/reports/cpg/cpg-report/cpg-report.component';
import { CreGeneralReportComponent } from '../../assessment/results/reports/reports/crePlus/cre-general-report/cre-general-report.component';
import { CreFinalReportComponent } from '../../assessment/results/reports/reports/crePlus/cre-final-report/cre-final-report.component';
import { CreDetailReportComponent } from '../../assessment/results/reports/reports/crePlus/cre-detail-report/cre-detail-report.component';
import { CrrCommentsMarkedComponent } from '../../assessment/results/reports/reports/crr/crr-comments-marked/crr-comments-marked.component';
import { CrrDeficiencyComponent } from '../../assessment/results/reports/reports/crr/crr-deficiency/crr-deficiency.component';
import { CrrReportComponent } from '../../assessment/results/reports/reports/crr/crr-report/crr-report.component';
import { EdmCommentsmarkedComponent } from '../../assessment/results/reports/reports/edm-commentsmarked/edm-commentsmarked.component';
import { ExecutiveSummaryComponent } from '../../assessment/results/reports/reports/executive-summary/executive-summary.component';
import { GeneralDeficiencyComponent } from '../../assessment/results/reports/reports/general-deficiency/general-deficiency.component';
import { HydroActionItemsReportComponent } from '../../assessment/results/reports/reports/hydro/hydro-action-items-report/hydro-action-items-report.component';
import { HydroReportComponent } from '../../assessment/results/reports/reports/hydro/hydro-report/hydro-report.component';
import { ImrReportComponent } from '../../assessment/results/reports/reports/imr/imr-report/imr-report.component';
import { ModuleContentComponent } from '../../assessment/results/reports/reports/module-content/module-content/module-content.component';
import { MvraReportComponent } from '../../assessment/results/reports/reports/mvra/mvra-report.component';
import { ObservationTearoutsComponent } from '../../assessment/results/reports/reports/observation-tearouts/observation-tearouts.component';
import { PhysicalSummaryComponent } from '../../assessment/results/reports/reports/physical-summary/physical-summary.component';
import { RraDeficiencyComponent } from '../../assessment/results/reports/reports/rra/rra-deficiency/rra-deficiency.component';
import { RraReportComponent } from '../../assessment/results/reports/reports/rra/rra-report/rra-report.component';
import { SdOwnerCommentsMfrComponent } from '../../assessment/results/reports/reports/sd-owner/sd-owner-comments/sd-owner-comments-mfr.component';
import { SdOwnerDeficiencyComponent } from '../../assessment/results/reports/reports/sd-owner/sd-owner-deficiency/sd-owner-deficiency.component';
import { SdAnswerSummaryReportComponent } from '../../assessment/results/reports/reports/sd/sd-answer-summary-report/sd-answer-summary-report.component';
import { SiteDetailComponent } from '../../assessment/results/reports/reports/site-detail/site-detail.component';
import { SiteSummaryComponent } from '../../assessment/results/reports/reports/site-summary/site-summary.component';
import { TrendReportComponent } from '../../assessment/results/reports/reports/trend-report/trend-report.component';
import { TsaSdComponent } from '../../assessment/results/reports/reports/tsa-sd/tsa-sd.component';
import { OpenEndedQuestionsComponent } from '../../assessment/results/reports/reports/vadr/open-ended-questions/open-ended-questions.component';
import { VadrDeficiencyComponent } from '../../assessment/results/reports/reports/vadr/vadr-deficiency/vadr-deficiency.component';
import { VadrReportComponent } from '../../assessment/results/reports/reports/vadr/vadr-report/vadr-report.component';
import { CisaVadrReportComponent } from '../../assessment/results/reports/reports/cisa-vadr/cisa-vadr-report/cisa-vadr-report.component';
import { CreHeatmapsComponent } from '../../assessment/results/reports/reports/crePlus/cre-heatmaps/cre-heatmaps.component';
import { DeficiencyTemplateComponent } from '../../assessment/results/reports/reports/deficiency-template/deficiency-template.component';
import { Cmmc2DeficiencyComponent } from '../../assessment/results/reports/reports/cmmc2/cmmc2-deficiency/cmmc2-deficiency.component';
import { Cmmc2ScorecardReportComponent } from '../../assessment/results/reports/reports/cmmc2/cmmc2-scorecard-report/cmmc2-scorecard-report.component';
import { Cmmc2CommentsMarkedComponent } from '../../assessment/results/reports/reports/cmmc2/cmmc2-comments-marked/cmmc2-comments-marked.component';
import { ExecutiveCMMC2Component } from '../../assessment/results/reports/reports/cmmc2/executive-cmmc2/executive-cmmc2.component';
import { EdmComponent } from '../../assessment/results/reports/reports/edm/edm.component';
import { SecurityplanComponent } from '../../assessment/results/reports/reports/securityplan/securityplan.component';



const routes: Routes = [
    { path: 'detail', component: SiteDetailComponent },
    { path: 'observations', component: ObservationTearoutsComponent },
    { path: 'executive', component: ExecutiveSummaryComponent },
    { path: 'securityplan', component: SecurityplanComponent },
    { path: 'sitesummary', component: SiteSummaryComponent },
    { path: 'physicalsummary', component: PhysicalSummaryComponent },
    { path: 'trend-report', component: TrendReportComponent },
    { path: 'compare-report', component: CompareReportComponent },
    { path: 'compare-report-m', component: CompareReportMComponent },
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
    { path: 'cre-general-report', component: CreGeneralReportComponent },
    { path: 'cre-detail-report', component: CreDetailReportComponent },
    { path: 'cre-final-report/:m', component: CreFinalReportComponent },
    { path: 'cre-model-chart-report/:m', component: CreDetailReportComponent },
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
    { path: 'allReviewedQuestions', component: AllReviewedComponent },
    { path: 'deficiency', component: DeficiencyTemplateComponent },
    { path: 'cmmc2DeficiencyReport', component: Cmmc2DeficiencyComponent },
    { path: 'cmmc2ScorecardReport', component: Cmmc2ScorecardReportComponent },
    { path: 'cmmc2CommentsMarked', component: Cmmc2CommentsMarkedComponent },
    { path: 'executivecmmc2', component: ExecutiveCMMC2Component },
    { path: 'edm', component: EdmComponent, }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class ReportRoutingModule { }