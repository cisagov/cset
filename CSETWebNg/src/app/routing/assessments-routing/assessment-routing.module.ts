import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SdAnswerSummaryComponent } from '../../assessment/results/sd/sd-answer-summary/sd-answer-summary.component';
import { DiagramInfoComponent } from '../../assessment/diagram/diagram-info/diagram-info.component';
import { DiagramComponent } from '../../assessment/diagram/diagram.component';
import { AssessmentConfigCieComponent } from '../../assessment/prepare/assessment-info/assessment-config-cie/assessment-config-cie.component';
import { AssessmentConfigIodComponent } from '../../assessment/prepare/assessment-info/assessment-config-iod/assessment-config-iod.component';
import { AssessmentDemogIodComponent } from '../../assessment/prepare/assessment-info/assessment-demog-iod/assessment-demog-iod.component';
import { AssessmentDetailCieComponent } from '../../assessment/prepare/assessment-info/assessment-detail-cie/assessment-detail-cie.component';
import { AssessmentInfoCieComponent } from '../../assessment/prepare/assessment-info/assessment-info-cie/assessment-info-cie.component';
import { AssessmentInfoNcuaComponent } from '../../assessment/prepare/assessment-info/assessment-info-ncua/assessment-info-ncua.component';
import { AssessmentInfoTsaComponent } from '../../assessment/prepare/assessment-info/assessment-info-tsa/assessment-info-tsa.component';
import { AssessmentInfoComponent } from '../../assessment/prepare/assessment-info/assessment-info.component';
import { AssessmentInfo2TsaComponent } from '../../assessment/prepare/assessment-info/assessment-info2-tsa/assessment-info2-tsa.component';
import { Assessment2InfoComponent } from '../../assessment/prepare/assessment-info/assessment2-info/assessment2-info.component';
import { CsiComponent } from '../../assessment/prepare/csi/csi.component';
import { FrameworkComponent } from '../../assessment/prepare/framework/framework.component';
import { ExamProfileSummaryComponent } from '../../assessment/prepare/irp-summary/irp-ise-summary.component';
import { IrpSummaryComponent } from '../../assessment/prepare/irp-summary/irp-summary.component';
import { ExamProfileComponent } from '../../assessment/prepare/irp/irp-ise.component';
import { IRPComponent } from '../../assessment/prepare/irp/irp.component';
import { CieAnalysisMatrixComponent } from '../../assessment/prepare/maturity/cie-example/cie-analysis-matrix/cie-analysis-matrix.component';
import { ApplyingCieComponent } from '../../assessment/prepare/maturity/cie-example/cie-analysis/applying-cie/applying-cie.component';
import { CieAnalysisComponent } from '../../assessment/prepare/maturity/cie-example/cie-analysis/cie-analysis.component';
import { PrincipleAnalysisCieComponent } from '../../assessment/prepare/maturity/cie-example/cie-analysis/principle-analysis-cie/principle-analysis-cie.component';
import { CieBackgroundComponent } from '../../assessment/prepare/maturity/cie-example/cie-background/cie-background.component';
import { CieExampleComponent } from '../../assessment/prepare/maturity/cie-example/cie-example.component';
import { CmmcLevelsComponent } from '../../assessment/prepare/maturity/cmmc-levels/cmmc-levels.component';
import { Cmmc2LevelsComponent } from '../../assessment/prepare/maturity/cmmc2-levels/cmmc2-levels.component';
import { ConfigCisComponent } from '../../assessment/prepare/maturity/config-cis/config-cis.component';
import { ModelSelectComponent } from '../../assessment/prepare/maturity/model-select/model-select.component';
import { HowToUseCieComponent } from '../../assessment/prepare/maturity/tutorial-cie/how-to-use-cie/how-to-use-cie.component';
import { PrepareComponent } from '../../assessment/prepare/prepare.component';
import { RequiredDocsComponent } from '../../assessment/prepare/required/required.component';
import { SalsComponent } from '../../assessment/prepare/sals/sals.component';
import { StandardsComponent } from '../../assessment/prepare/standards/standards.component';
import { DiagramQuestionsComponent } from '../../assessment/questions/diagram-questions/diagram-questions.component';
import { MaturityQuestionsAcetComponent } from '../../assessment/questions/maturity-questions/maturity-questions-acet.component';
import { MaturityQuestionsCieComponent } from '../../assessment/questions/maturity-questions/maturity-questions-cie/maturity-questions-cie.component';
import { MaturityQuestionsIseComponent } from '../../assessment/questions/maturity-questions/maturity-questions-ise.component';
import { MaturityQuestionsComponent } from '../../assessment/questions/maturity-questions/maturity-questions.component';
import { MaturityQuestionsNestedComponent } from '../../assessment/questions/maturity-questions/nested/maturity-questions-nested/maturity-questions-nested.component';
import { OtherRemarksComponent } from '../../assessment/questions/other-remarks/other-remarks.component';
import { PlaceholderQuestionsComponent } from '../../assessment/questions/placeholder-questions/placeholder-questions.component';
import { PrincipleSummaryComponent } from '../../assessment/questions/principle-summary/principle-summary.component';
import { QuestionBlockCieComponent } from '../../assessment/questions/question-block-cie/question-block-cie.component';
import { QuestionsComponent } from '../../assessment/questions/questions.component';
import { AcetDetailComponent } from '../../assessment/results/acet-detail/acet-detail.component';
import { AnalysisComponent } from '../../assessment/results/analysis/analysis.component';
import { ComponentsRankedComponent } from '../../assessment/results/analysis/components-ranked/components-ranked.component';
import { ComponentsResultsComponent } from '../../assessment/results/analysis/components-results/components-results.component';
import { ComponentsSummaryComponent } from '../../assessment/results/analysis/components-summary/components-summary.component';
import { ComponentsTypesComponent } from '../../assessment/results/analysis/components-types/components-types.component';
import { ComponentsWarningsComponent } from '../../assessment/results/analysis/components-warnings/components-warnings.component';
import { DashboardComponent } from '../../assessment/results/analysis/dashboard/dashboard.component';
import { RankedQuestionsComponent } from '../../assessment/results/analysis/ranked-questions/ranked-questions.component';
import { StandardsRankedComponent } from '../../assessment/results/analysis/standards-ranked/standards-ranked.component';
import { StandardsResultsComponent } from '../../assessment/results/analysis/standards-results/standards-results.component';
import { StandardsSummaryComponent } from '../../assessment/results/analysis/standards-summary/standards-summary.component';
import { AnalyticsCompareComponent } from '../../assessment/results/analytics-compare/analytics-compare.component';
import { AnalyticsResultsComponent } from '../../assessment/results/analytics-results/analytics-results.component';
import { AnalyticsComponent } from '../../assessment/results/analytics/analytics.component';
import { RankedDeficiencyComponent } from '../../assessment/results/cis/ranked-deficiency/ranked-deficiency.component';
import { SectionScoringComponent } from '../../assessment/results/cis/section-scoring/section-scoring.component';
import { CpgPracticesComponent } from '../../assessment/results/cpg/cpg-practices/cpg-practices.component';
import { CpgSummaryComponent } from '../../assessment/results/cpg/cpg-summary/cpg-summary.component';
import { CrrResultsPage } from '../../assessment/results/crr/crr-results-page/crr-results-page.component';
import { CrrSummaryResultsComponent } from '../../assessment/results/crr/crr-summary-results/crr-summary-results.component';
import { AcetDashboardComponent } from '../../assessment/results/dashboard/acet-dashboard.component';
import { MaturityIndicatorLevelsComponent } from '../../assessment/results/edm/maturity-indicator-levels/maturity-indicator-levels.component';
import { RelationshipFormationComponent } from '../../assessment/results/edm/relationship-formation/relationship-formation.component';
import { RelationshipManagementComponent } from '../../assessment/results/edm/relationship-management/relationship-management.component';
import { ServiceProtectionComponent } from '../../assessment/results/edm/service-protection/service-protection.component';
import { SummaryResultsComponent } from '../../assessment/results/edm/summary-results/summary-results.component';
import { FeedbackComponent } from '../../assessment/results/feedback/feedback.component';
import { HydroActionsComponent } from '../../assessment/results/hydro/hydro-actions/hydro-actions.component';
import { HydroDeficiencyComponent } from '../../assessment/results/hydro/hydro-deficiency/hydro-deficiency.component';
import { HydroFeasibilityComponent } from '../../assessment/results/hydro/hydro-feasibility/hydro-feasibility.component';
import { HydroImpactComponent } from '../../assessment/results/hydro/hydro-impact/hydro-impact.component';
import { CmmcComplianceComponent } from '../../assessment/results/mat-cmmc/cmmc-compliance/cmmc-compliance.component';
import { CmmcGapsComponent } from '../../assessment/results/mat-cmmc/cmmc-gaps/cmmc-gaps.component';
import { CmmcLevelDrilldownComponent } from '../../assessment/results/mat-cmmc/cmmc-level-drilldown/cmmc-level-drilldown.component';
import { CmmcLevelResultsComponent } from '../../assessment/results/mat-cmmc/cmmc-level-results/cmmc-level-results.component';
import { Cmmc2DomainResultsComponent } from '../../assessment/results/mat-cmmc2/cmmc2-domain-results/cmmc2-domain-results.component';
import { Cmmc2LevelResultsComponent } from '../../assessment/results/mat-cmmc2/cmmc2-level-results/cmmc2-level-results.component';
import { Cmmc2ScoresComponent } from '../../assessment/results/mat-cmmc2/cmmc2-scores/cmmc2-scores.component';
import { Cmmc2ScorecardPageComponent } from '../../assessment/results/mat-cmmc2/scorecard/cmmc2-scorecard/cmmc2-scorecard-page.component';
import { SprsScoreComponent } from '../../assessment/results/mat-cmmc2/scorecard/sprs-score/sprs-score.component';
import { MvraGapsPageComponent } from '../../assessment/results/mat-mvra/mvra-gaps-page/mvra-gaps-page.component';
import { MvraSummaryPageComponent } from '../../assessment/results/mat-mvra/mvra-summary-page/mvra-summary-page.component';
import { RraGapsComponent } from '../../assessment/results/mat-rra/rra-gaps/rra-gaps.component';
import { RraLevelResultsComponent } from '../../assessment/results/mat-rra/rra-level-results/rra-level-results.component';
import { RraSummaryAllComponent } from '../../assessment/results/mat-rra/rra-summary-all/rra-summary-all.component';
import { OverviewComponent } from '../../assessment/results/overview/overview.component';
import { ReportsComponent } from '../../assessment/results/reports/reports.component';
import { ResultsComponent } from '../../assessment/results/results.component';
import { TsaAssessmentCompleteComponent } from '../../assessment/results/tsa-assessment-complete/tsa-assessment-complete.component';
import { AssessGuard } from '../../guards/assess.guard';

const routes: Routes = [
    {
        path: 'prepare',
        component: PrepareComponent,
        canActivate: [AssessGuard],
        canActivateChild: [AssessGuard],
        children: [
            { path: '', loadChildren: () => import('./assessment-tutorial.module').then(m => m.AssessmentTutorialRoutingModule) },
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
            { path: 'cmmc2-levels', component: Cmmc2LevelsComponent },
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
            { path: 'cmmc2-scores', component: Cmmc2ScoresComponent },
            { path: 'cmmc2-scorecard', component: Cmmc2ScorecardPageComponent },
            { path: 'cmmc2-level-results', component: Cmmc2LevelResultsComponent },
            { path: 'cmmc2-domain-results', component: Cmmc2DomainResultsComponent },
            { path: 'rra-summary-all', component: RraSummaryAllComponent },
            { path: 'rra-level-results', component: RraLevelResultsComponent },
            { path: 'rra-gaps', component: RraGapsComponent },
            { path: 'mvra-gaps-page', component: MvraGapsPageComponent },
            { path: 'mvra-summary-page', component: MvraSummaryPageComponent },
            { path: 'cpg-summary-page', component: CpgSummaryComponent },
            { path: 'cpg-practices-page', component: CpgPracticesComponent },
            { path: 'analytics-results-page', component: AnalyticsResultsComponent },
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
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class AssessmentRoutingModule { }