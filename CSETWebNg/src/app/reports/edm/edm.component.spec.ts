import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EdmComponent } from './edm.component';

describe('EdmComponent', () => {
  let component: EdmComponent;
  let fixture: ComponentFixture<EdmComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EdmComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EdmComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
