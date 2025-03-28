import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TutorialCisComponent } from '../../assessment/prepare/maturity/tutorial-cis/tutorial-cis.component';
import { TutorialCmmcComponent } from '../../assessment/prepare/maturity/tutorial-cmmc/tutorial-cmmc.component';
import { TutorialCmmc2Component } from '../../assessment/prepare/maturity/tutorial-cmmc2/tutorial-cmmc2.component';
import { TutorialCpgComponent } from '../../assessment/prepare/maturity/tutorial-cpg/tutorial-cpg.component';
import { TutorialCrrComponent } from '../../assessment/prepare/maturity/tutorial-crr/tutorial-crr.component';
import { TutorialEdmComponent } from '../../assessment/prepare/maturity/tutorial-edm/tutorial-edm.component';
import { TutorialImrComponent } from '../../assessment/prepare/maturity/tutorial-imr/tutorial-imr.component';
import { TutorialMvraComponent } from '../../assessment/prepare/maturity/tutorial-mvra/tutorial-mvra.component';
import { TutorialRraComponent } from '../../assessment/prepare/maturity/tutorial-rra/tutorial-rra.component';
import { TutorialCieComponent } from '../../assessment/prepare/maturity/tutorial-cie/tutorial-cie.component';
import { BackgroundCieComponent } from '../../assessment/prepare/maturity/tutorial-cie/background-cie/background-cie.component';
import { LifecycleCieComponent } from '../../assessment/prepare/maturity/tutorial-cie/lifecycle-cie/lifecycle-cie.component';
import { OverviewCieComponent } from '../../assessment/prepare/maturity/tutorial-cie/overview-cie/overview-cie.component';
import { PrinciplesCieComponent } from '../../assessment/prepare/maturity/tutorial-cie/principles-cie/principles-cie.component';
import { QuickFactsCieComponent } from '../../assessment/prepare/maturity/tutorial-cie/quick-facts-cie/quick-facts-cie.component';

const routes: Routes = [
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
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class AssessmentTutorialRoutingModule { }