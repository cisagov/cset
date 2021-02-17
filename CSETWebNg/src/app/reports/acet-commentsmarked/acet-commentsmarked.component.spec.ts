import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AcetCommentsmarkedComponent } from './acet-commentsmarked.component';

describe('AcetCommentsmarkedComponent', () => {
  let component: AcetCommentsmarkedComponent;
  let fixture: ComponentFixture<AcetCommentsmarkedComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AcetCommentsmarkedComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AcetCommentsmarkedComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
