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
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { IRPService } from '../../../services/irp.service';
import { IRPResponse, IRP } from '../../../models/irp.model';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { ACETService } from '../../../services/acet.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
    selector: 'app-irp',
    templateUrl: './irp.component.html',
    styleUrls: ['./irp.component.scss']
})
export class IRPComponent implements OnInit {
    irps: IRPResponse;
    selected: IRP;

    constructor(private router: Router,
        public assessSvc: AssessmentService,
        public navSvc: NavigationService,
        private irpSvc: IRPService,
        public acetSvc: ACETService,
        public tSvc: TranslocoService
    ) { }

    ngOnInit() {
        this.tSvc.langChanges$.subscribe((event) => {
            this.loadFrameworks();
        });
    }

    loadFrameworks() {
        this.irpSvc.getIRPList().subscribe(
            (data: IRPResponse) => {
                this.irps = data;
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    setResponse(irp: IRP, val) {
        irp.response = val;
        this.irpSvc.postSelection(irp).subscribe();
    }

}
