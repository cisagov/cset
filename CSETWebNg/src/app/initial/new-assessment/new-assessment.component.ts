import { NumberSymbol } from '@angular/common';
import { AfterViewInit, Component, NgZone, OnInit, ViewChild, ViewEncapsulation } from '@angular/core';
import SwiperCore, { SwiperOptions, Navigation, Pagination, Virtual } from 'swiper';
import { MatDialog} from '@angular/material/dialog';
import { NewAssessmentDialogComponent } from '../../dialogs/new-assessment-dialog/new-assessment-dialog.component';
import {
  BreakpointObserver,
  Breakpoints,
  BreakpointState
} from '@angular/cdk/layout';
import { SwiperComponent } from 'swiper/angular';
import { GalleryService } from '../../services/gallery.service';
import { trigger, style, animate, transition,state } from '@angular/animations';

SwiperCore.use([Navigation, Pagination, Virtual]);
@Component({
  selector: 'app-new-assessment',
  templateUrl: './new-assessment.component.html',
  styleUrls: ['./new-assessment.component.scss'], 
  encapsulation: ViewEncapsulation.None,
  animations: [
    trigger('enterAnimation', [
      state('false', style({ overflow: 'hidden', height: '0px',padding:'0 10px 0 0'})),
      state('true', style({ overflow: 'hidden', height: '*', padding:'0 10px 10px 0'})),
      transition('false => true', animate('200ms ease-in')),
      transition('true => false', animate('200ms ease-out'))
    ]),
  ]
})
export class NewAssessmentComponent implements OnInit, AfterViewInit {

  @ViewChild('swiper', {static: false}) swiper?: SwiperComponent;

  hoverIndex = -1;  
  config: SwiperOptions = {
    slidesPerView: 1,
    spaceBetween: 5,
    slidesPerGroup: 1, 
    //loop:true, 
    navigation:true,
    breakpoints: {
      200: {
        slidesPerView:1,
      },
      620:{
        slidesPerView:2,
      },
      800: {
        slidesPerView: 3, 
      },
      1220:{
        slidesPerView:4,
      },
      1460:{
        slidesPerView:5
      }
    }, 
    on: {
      resize: ()=>{
        this.checkNavigation();
      }
    }
  };

  galleryData: any;
  rows: any;
  testRow: any;
  show:boolean = false;

  constructor(public dialog:MatDialog, 
    public breakpointObserver: BreakpointObserver, 
    public gallerySvc: GalleryService) { 
    
  }

  ngOnInit(): void {
    this.gallerySvc.getGalleryItems("CSET").subscribe(
      (resp: any) => {
        this.galleryData = resp;
        this.rows = this.galleryData.rows;
        this.testRow = this.rows[1];
        console.log(this.testRow);
        console.log(this.rows);
      }
    );
    setTimeout(() => {
      this.checkNavigation();
    });
    
  }
  ngAfterViewInit(): void {
    this.checkNavigation();
  }

  checkNavigation(){
    let swiperPrev = document.querySelector('.swiper-button-prev');
    let swiperNext = document.querySelector('.swiper-button-next');
    if(window.innerWidth < 620){
     
      if(swiperPrev != null && swiperNext != null){
        swiperPrev.setAttribute('style','display:none');
        swiperNext.setAttribute('style','display:none');
      }
    } else {
      if(swiperPrev != null && swiperNext != null){
        swiperPrev.removeAttribute('style');
        swiperNext.removeAttribute('style');
      }
    }
  }

   onSwiper([swiper]){
      console.log(swiper);
  }
  onHover(i:number){
    this.hoverIndex = i;
  }

  showButtons(show: boolean){
    this.show=show;
  }

  onSlideChange(){}

  openDialog(data: any ){
    this.dialog.open(NewAssessmentDialogComponent, {
      panelClass: 'new-assessment-dialog-responsive',
      data:data
    });
  }
}
