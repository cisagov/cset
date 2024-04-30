import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AnalyticsService } from '../../../services/analytics.service';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { strict } from 'assert';
//import { DataloginComponent } from '../analysis/submitdata/datalogin/datalogin.component';
import { MatDialog } from '@angular/material/dialog';
import { ConfigService } from '../../../services/config.service';
import { AlertComponent } from '../../../dialogs/alert/alert.component';
import { AnalyticsloginComponent } from '../analysis/analytics-login/analytics-login.component';

@Component({
    selector: 'app-analytics',
    templateUrl: './analytics.component.html',
    styleUrls: ['./analytics.component.scss']
})
export class AnalyticsComponent implements OnInit {

    analytics: any = {
        demographics: {
            sectorId: 0,
            industryId: 0,
            sectorName: '',
            industryName: '',
            assets: '',
            size: '', 
            alias: ''
        },
        questionAnswers: []
    };

    username: string = '';
    password: string = '';

    constructor(private router: Router,
        public navSvc: NavigationService,
        public analyticsSvc: AnalyticsService,
        private route: ActivatedRoute,
        private snackBar: MatSnackBar,
        private dialog: MatDialog,
        private config: ConfigService
    ) { }

    ngOnInit() {
        this.navSvc.navItemSelected.asObservable().subscribe((value: string) => {
            this.router.navigate([value], { relativeTo: this.route.parent });
        });
        this.route.params.subscribe(params => {
            this.getAnalytics();
        });
    }

    getAnalytics() {
        this.analyticsSvc.getAnalytics().subscribe(
            (data: any) => {
                this.analytics = data;
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    /**
     * Submit With Login
     */
    showLogin() {
       const dialogRef = this.dialog.open(AnalyticsloginComponent, {
            width: '300px',
            disableClose: true,
            data: this.analytics
        }).afterClosed().subscribe(info => {
            if (!!info && info.cancel) {
                // user canceled, do nothing
            } else {
                window.open(this.config.analyticsUrl + "index.html", "_blank");
            }
        });
    }

    getRawData() {
        return JSON.stringify(this.analytics);
    }
    /**
     * 
     * @param val 
     */
    isNullOrEmpty(val) {
        if (!val || val.length == 0) {
            return true;
        }
        return false;
    }

    openSnackBar(message) {
        this.snackBar.open(message, "", {
            duration: 4000,
            verticalPosition: 'top',
            panelClass: ['green-snackbar']
        });
    }
}
