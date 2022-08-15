import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrCoverSheetComponent } from './crr-cover-sheet.component';

describe('CrrCoverSheetComponent', () => {
  let component: CrrCoverSheetComponent;
  let fixture: ComponentFixture<CrrCoverSheetComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrCoverSheetComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrCoverSheetComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
