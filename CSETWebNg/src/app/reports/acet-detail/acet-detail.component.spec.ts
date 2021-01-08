import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AcetDetailComponent } from './acet-detail.component';

describe('AcetDetailComponent', () => {
  let component: AcetDetailComponent;
  let fixture: ComponentFixture<AcetDetailComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AcetDetailComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AcetDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
