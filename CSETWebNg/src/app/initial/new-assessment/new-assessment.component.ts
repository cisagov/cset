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
import { AfterViewInit, Component, OnInit, ViewEncapsulation, OnDestroy } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { NewAssessmentDialogComponent } from '../../dialogs/new-assessment-dialog/new-assessment-dialog.component';
import { GalleryService } from '../../services/gallery.service';
import { trigger, style, animate, transition, state } from '@angular/animations';
import { NavigationService } from '../../services/navigation/navigation.service';
import { TranslocoService } from '@jsverse/transloco';
import { AuthenticationService } from '../../services/authentication.service';
import { Subscription } from 'rxjs';



@Component({
  selector: 'app-new-assessment',
  standalone: false,
  templateUrl: './new-assessment.component.html',
  styleUrls: ['./new-assessment.component.scss'],
  encapsulation: ViewEncapsulation.None,
  animations: [
    trigger('enterAnimation', [
      state('false', style({ overflow: 'hidden', height: '0px', padding: '0 10px 0 0' })),
      state('true', style({ overflow: 'hidden', height: '*', padding: '0 10px 10px 0' })),
      transition('false => true', animate('200ms ease-in')),
      transition('true => false', animate('200ms ease-out'))
    ]),
  ],
})
export class NewAssessmentComponent implements OnInit, AfterViewInit , OnDestroy{
  hoverIndex = -1;
  selectedCategory = 'favorites';
  selectedCategoryId:number |null = null;
  loadingCardId:number |null = null;
  private langChangeSubscription: Subscription;


  constructor(
    public dialog: MatDialog,
    public gallerySvc: GalleryService,
    public navSvc: NavigationService,
    public tSvc: TranslocoService,
    private authSvc: AuthenticationService,
  ) {
  }

  ngOnInit(): void {
    this.gallerySvc.refreshCards();
    this.langChangeSubscription = this.tSvc.langChanges$.subscribe((lang: string) => {
      // Wait for the language to be saved to backend, THEN refresh
      this.authSvc.setUserLang(lang).subscribe(() => {
        this.gallerySvc.refreshCards();
      });
    });
  }

  ngAfterViewInit() {

  }
  ngOnDestroy(): void {
    this.loadingCardId = null;
    if (this.langChangeSubscription) {
      this.langChangeSubscription.unsubscribe();
    }
  }
  getImageSrc(src: string) {
    let path = "assets/images/cards/";
    if (src) {
      return path + src.toLowerCase();
    }
    return path + 'default.png';
  }

  onHover(i: number) {
    this.hoverIndex = i;
    if (i > 0) {
      var el = document.getElementById('c' + i.toString())?.parentElement;

      var bounding = el.getBoundingClientRect();

      let cardDimension = { x: bounding.x, y: bounding.y, w: bounding.width, h: bounding.height };
      let viewport = { x: 0, y: 0, w: window.innerWidth, h: window.innerHeight };
      let xOverlap = Math.max(0, Math.min(cardDimension.x + cardDimension.w, viewport.x + viewport.w) - Math.max(cardDimension.x, viewport.x))
      //let yOverlap = Math.max(0, Math.min(cardDimension.y + cardDimension.y, viewport.y + viewport.h) - Math.max(cardDimension.y, viewport.y))
      let offScreen = cardDimension.w - xOverlap;
      if (offScreen > 5) {
        el.style.right = (cardDimension.w).toString() + 'px';
      }
    }
  }

  onHoverOut(i: number, cardId: number) {
    this.hoverIndex = i;

    var el = document.getElementById('c' + cardId.toString())?.parentElement;
    el.style.removeProperty('right');
  }

  openDialog(data: any) {
    data.path = this.getImageSrc(data.icon_File_Name_Small);
    this.dialog.open(NewAssessmentDialogComponent, {
      panelClass: 'new-assessment-dialog-responsive',
      data: data
    });
  }

  selectCategory(category: string): void {
    if(category==='favorites') {
      this.selectedCategory = 'favorites';
      this.selectedCategoryId = null;
    }
   else{
      const selectedRow = this.gallerySvc.rows?.find(row => row.group_Title === category);
      if (selectedRow) {
        this.selectedCategoryId = selectedRow.group_Id;
        this.selectedCategory = null;
      }
    }
  }
  getFavoritesCount(): number {
    return this.getUniqueFavorites().length;
  }
  getFilteredItems(): any[] {
    if (!this.gallerySvc.rows || !Array.isArray(this.gallerySvc.rows)) {
      return [];
    }
    if (this.selectedCategory === 'favorites') {
      return this.getUniqueFavorites();
    }
    //  not lost the categories when language changes
    if (this.selectedCategoryId !== null) {
      const selectedRow = this.gallerySvc.rows.find(row => row.group_Id === this.selectedCategoryId);
      return selectedRow && selectedRow.galleryItems ? selectedRow.galleryItems : [];
    }
    return [];
  }
  getSelectedCategoryTitle(): string {
    if (this.selectedCategory === 'favorites') {
      return this.tSvc.translate('favorites');
    }

    if (this.selectedCategoryId !== null) {
      const selectedRow = this.gallerySvc.rows?.find(row => row.group_Id === this.selectedCategoryId);
      return selectedRow ? selectedRow.group_Title : '';
    }

    return this.tSvc.translate('all assessments');
  }
  getCategoryIcon(categoryTitle: string): string {
    const iconMap: { [key: string]: string } = {
      'Most Popular': 'fas fa-star',
      'CISA Sponsored': 'fas fa-shield-alt',
      'Maturity Models': 'fas fa-chart-line',
      'Energy and Electrical': 'fas fa-bolt',
      'Industrial and Utilities': 'fas fa-industry',
      'Municipal and Health Care': 'fas fa-hospital',
      'NIST Special Publications': 'fas fa-book',
      'Financial': 'fas fa-dollar-sign',
      'Transportation': 'fas fa-truck',
      'Other': 'fas fa-ellipsis-h'
    };

    return iconMap[categoryTitle] || 'fas fa-folder';
  }

  /**
   * Toggle favorite status
   */
  toggleFavorite(event: Event, card: any): void {
    event.stopPropagation(); // Prevent card click or other events
    const newFavoriteStatus = !card.isFavorite;
    this.gallerySvc.toggleFavorite(card.gallery_Item_Guid, newFavoriteStatus).subscribe(
      () => {
        // Update local state immediately
        card.isFavorite = newFavoriteStatus;
        this.gallerySvc.galleryData.rows.forEach((row: any) => {
          row.galleryItems.forEach((item: any) => {
            if (item.gallery_Item_Guid == card.gallery_Item_Guid) {
              item.isFavorite = card.isFavorite;
            }
          });
        });
      },
      (error) => {
        console.error('Error toggling favorite:', error);
        alert('Failed to update favorite. Please try again.');
      }
    );
  }
  private getUniqueFavorites():any[]{
    if (!this.gallerySvc.rows || !Array.isArray(this.gallerySvc.rows)) {
      return [];
    }
    const allFavorites = this.gallerySvc.rows.reduce((acc, row) => {
      const favoriteItems = row.galleryItems?.filter(item => item.isFavorite) || [];
      return acc.concat(favoriteItems);
    }, []);
    const uniqueFavorite = new Map();
    allFavorites.forEach(fav => {
      uniqueFavorite.set(fav.gallery_Item_Guid, fav);
    });

    return Array.from(uniqueFavorite.values());
  }
  onCardClick(card: any): void {
    this.loadingCardId = card.gallery_Item_Guid;
    this.navSvc.beginNewAssessmentGallery(card)
      .catch((error) => {
        console.error('Navigation failed:', error);
        this.loadingCardId = null;
      });
  }
}
