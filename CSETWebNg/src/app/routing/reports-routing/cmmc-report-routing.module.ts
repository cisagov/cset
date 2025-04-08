import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CmmcAltJustificationsComponent } from '../../reports/cmmc/cmmc-alt-justifications/cmmc-alt-justifications.component';
import { CmmcCommentsMarkedComponent } from '../../reports/cmmc/cmmc-comments-marked/cmmc-comments-marked.component';
import { CmmcDeficiencyComponent } from '../../reports/cmmc/cmmc-deficiency/cmmc-deficiency.component';
import { ExecutiveCMMCComponent } from '../../reports/cmmc/executive-cmmc/executive-cmmc.component';
import { SitesummaryCMMCComponent } from '../../reports/cmmc/sitesummary-cmmc/sitesummary-cmmc.component';
import { Cmmc2CommentsMarkedComponent } from '../../reports/cmmc2/cmmc2-comments-marked/cmmc2-comments-marked.component';
import { Cmmc2DeficiencyComponent } from '../../reports/cmmc2/cmmc2-deficiency/cmmc2-deficiency.component';
import { Cmmc2ScorecardReportComponent } from '../../reports/cmmc2/cmmc2-scorecard-report/cmmc2-scorecard-report.component';
import { ExecutiveCMMC2Component } from '../../reports/cmmc2/executive-cmmc2/executive-cmmc2.component';

const routes: Routes = [
    { path: 'executivecmmc', component: ExecutiveCMMCComponent },
    { path: 'sitesummarycmmc', component: SitesummaryCMMCComponent },
    { path: 'cmmcDeficiencyReport', component: CmmcDeficiencyComponent },
    { path: 'cmmcCommentsMarked', component: CmmcCommentsMarkedComponent },
    { path: 'cmmcAltJustifications', component: CmmcAltJustificationsComponent },
    { path: 'cmmc2DeficiencyReport', component: Cmmc2DeficiencyComponent },
    { path: 'cmmc2ScorecardReport', component: Cmmc2ScorecardReportComponent },
    { path: 'cmmc2CommentsMarked', component: Cmmc2CommentsMarkedComponent },
    { path: 'executivecmmc2', component: ExecutiveCMMC2Component },
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class CmmcReportRoutingModule { }
