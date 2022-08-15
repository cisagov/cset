import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrSideTocComponent } from './crr-side-toc.component';

describe('CrrSideTocComponent', () => {
  let component: CrrSideTocComponent;
  let fixture: ComponentFixture<CrrSideTocComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrSideTocComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrSideTocComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
