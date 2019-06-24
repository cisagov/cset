import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { IRPService } from '../../../services/irp.service';
import { IRPResponse, IRP } from '../../../models/irp.model';
import { Navigation2Service } from '../../../services/navigation2.service';

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
        public navSvc2: Navigation2Service,
        private irpSvc: IRPService
    ) { }

    ngOnInit() {
        this.loadFrameworks();
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
        irp.Response = val;
        this.irpSvc.postSelection(irp).subscribe();
    }

    submit(irpId, response, comment) {
        this.selected = new IRP(irpId, response, comment);

        this.irpSvc.postSelection(this.selected).subscribe();
    }
}
