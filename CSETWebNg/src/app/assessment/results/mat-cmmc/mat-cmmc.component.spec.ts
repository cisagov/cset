import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MatCmmcComponent } from './mat-cmmc.component';

describe('MatCmmcComponent', () => {
  let component: MatCmmcComponent;
  let fixture: ComponentFixture<MatCmmcComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MatCmmcComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MatCmmcComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
