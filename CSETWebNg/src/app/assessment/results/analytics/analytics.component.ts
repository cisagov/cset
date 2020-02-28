////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { ActivatedRoute, Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AnalyticsService } from '../../../services/analytics.service';
import { Navigation2Service } from '../../../services/navigation2.service';
import { NavigationService } from '../../../services/navigation.service';
import { strict } from 'assert';
import { DataloginComponent } from '../analysis/submitdata/datalogin/datalogin.component';
import { MatDialogRef, MatDialog } from '@angular/material';

@Component({
    selector: 'app-analytics',
    templateUrl: './analytics.component.html',
    styleUrls: ['./analytics.component.scss']
})
export class AnalyticsComponent implements OnInit {

    analytics:any = {
        Demographics:{
            SectorName:'',
            IndustryName:'',
            AssetValue:'',
            Size:''
        },
        QuestionAnswers:[]
    };

    username:string='';
    password:string='';
    
    constructor(private router: Router,
        public navSvc2: Navigation2Service,
        public navSvc: NavigationService,
        public analyticsSvc: AnalyticsService,
        private route: ActivatedRoute,
        private snackBar: MatSnackBar,
        private dialog: MatDialog
    ) { }

    ngOnInit() {
        this.getAnalytics();

        this.navSvc.itemSelected.asObservable().subscribe((value: string) => {
            this.router.navigate([value], { relativeTo: this.route.parent });
          });
    }

    getAnalytics(){
        this.analyticsSvc.getAnalytics().subscribe(
            (data: any) => {
                this.analytics = data;
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    postAnalyticsWithoutLogin(){
        var message;
        this.analyticsSvc.postAnalyticsWithoutLogin(this.analytics).subscribe(
            (data: any)=>{
                message = data.message;
                this.openSnackBar(message);
            });
    }

   

    showLogin(){
        const dialogRef = this.dialog.open(DataloginComponent, {
            width:'300px',
            disableClose: true,
            data: this.analytics
        });
    }

    openSnackBar(message){
        this.snackBar.open(message, "", {
            duration:4000,
            verticalPosition:'top',
            panelClass:['green-snackbar']
        });
    }

    getRawData(){
        return JSON.stringify(this.analytics);
    }

    checkValue(val){
        if(val){
            return true;
        }
        return false;
    }



}
