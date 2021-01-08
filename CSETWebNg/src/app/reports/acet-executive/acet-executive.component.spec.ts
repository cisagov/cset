import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AcetExecutiveComponent } from './acet-executive.component';

describe('AcetExecutiveComponent', () => {
  let component: AcetExecutiveComponent;
  let fixture: ComponentFixture<AcetExecutiveComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AcetExecutiveComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AcetExecutiveComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
