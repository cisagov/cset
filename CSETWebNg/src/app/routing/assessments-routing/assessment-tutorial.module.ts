////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { TutorialCisComponent } from '../../assessment/prepare/maturity/tutorial-cis/tutorial-cis.component';
import { TutorialCmmcComponent } from '../../assessment/prepare/maturity/tutorial-cmmc/tutorial-cmmc.component';
import { TutorialCmmc2Component } from '../../assessment/prepare/maturity/tutorial-cmmc2/tutorial-cmmc2.component';
import { TutorialCpgComponent } from '../../assessment/prepare/maturity/tutorial-cpg/tutorial-cpg.component';
import { TutorialCrrComponent } from '../../assessment/prepare/maturity/tutorial-crr/tutorial-crr.component';
import { TutorialEdmComponent } from '../../assessment/prepare/maturity/tutorial-edm/tutorial-edm.component';
import { TutorialImrComponent } from '../../assessment/prepare/maturity/tutorial-imr/tutorial-imr.component';
import { TutorialMvraComponent } from '../../assessment/prepare/maturity/tutorial-mvra/tutorial-mvra.component';
import { TutorialRraComponent } from '../../assessment/prepare/maturity/tutorial-rra/tutorial-rra.component';
import { TutorialCpg2Component } from '../../assessment/prepare/maturity/tutorial-cpg2/tutorial-cpg2.component';


const routes: Routes = [
    { path: 'tutorial-cmmc', component: TutorialCmmcComponent },
    { path: 'tutorial-cmmc2', component: TutorialCmmc2Component },
    { path: 'tutorial-edm', component: TutorialEdmComponent },
    { path: 'tutorial-crr', component: TutorialCrrComponent },
    { path: 'tutorial-imr', component: TutorialImrComponent },
    { path: 'tutorial-rra', component: TutorialRraComponent },
    { path: 'tutorial-cis', component: TutorialCisComponent },
    { path: 'tutorial-cpg', component: TutorialCpgComponent },
    { path: 'tutorial-cpg2', component: TutorialCpg2Component },
    { path: 'tutorial-mvra', component: TutorialMvraComponent }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class AssessmentTutorialRoutingModule { }