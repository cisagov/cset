import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CisCommentsmarkedComponent } from './cis-commentsmarked.component';

describe('CisCommentsmarkedComponent', () => {
  let component: CisCommentsmarkedComponent;
  let fixture: ComponentFixture<CisCommentsmarkedComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CisCommentsmarkedComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CisCommentsmarkedComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
