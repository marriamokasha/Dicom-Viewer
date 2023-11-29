classdef BonusTask_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DicomViewer          matlab.ui.Figure
        BrowseButton         matlab.ui.control.Button
        SagittalSlidesLabel  matlab.ui.control.Label
        ObliqueSlidesLabel   matlab.ui.control.Label
        AxialSlidesLabel     matlab.ui.control.Label
        CoronalSlidesLabel   matlab.ui.control.Label
        PolygonButton        matlab.ui.control.Button
        LineButton           matlab.ui.control.Button
        EllipseButton        matlab.ui.control.Button
        AngleButton          matlab.ui.control.Button
        MeasureLabel         matlab.ui.control.Label
        ValueEditField       matlab.ui.control.EditField
        unitLabel            matlab.ui.control.Label
        AxialAxes            matlab.ui.control.UIAxes
        CoronalAxes          matlab.ui.control.UIAxes
        SagittalAxes         matlab.ui.control.UIAxes
        ObliqueAxes          matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        Axial
        Sagittal
        Coronal
        AxialMidPoint
        SagittalMidPoint
        CoronalMidPoint
        axialVertical
        axialHorizontal
        sagittalVertical
        sagittalHorizontal
        coronalVertical
        coronalHorizontal
        obliqueLine
        V
        B
        x1
        x2
        y1
        y2
        chcoordinate
        ahcoordinate
        svcoordinate
        shcoordinate
        cvcoordinate
        avcoordinate
        angle
    end
 
    
    methods (Access = private)
        
        function AxialVerticalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    
                    app.avcoordinate=round(evt.CurrentPosition(1,1));
                    app.coronalVertical.Position=[app.avcoordinate 0; app.avcoordinate app.Axial];
                    imshow(rot90(permute(app.V(:,app.avcoordinate,:),[1 3 2])),[],'Parent' ,app.SagittalAxes);
                    disp(app.avcoordinate);
                    app.svcoordinate=app.ahcoordinate;
                    app.shcoordinate=app.chcoordinate;
                    app.sagittalVertical=drawline('Parent',app.SagittalAxes,'Position',[app.svcoordinate 0; app.svcoordinate app.Axial],'LineWidth',0.25,'Color','r','InteractionsAllowed','translate');
                    app.sagittalVertical.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                    app.sagittalHorizontal=drawline('Parent',app.SagittalAxes,'Position',[0 app.shcoordinate; app.Coronal app.shcoordinate],'LineWidth',0.25,'Color','g','InteractionsAllowed','translate');
                    app.sagittalHorizontal.DrawingArea = [0,0,(app.Coronal),(app.Axial)]; 
                    addlistener(app.sagittalVertical,'ROIMoved',@app.SagittalVerticalChanging);
                    addlistener(app.sagittalHorizontal,'ROIMoved',@app.SagittalHorizontalChanging);  
            end     
        end
        
        function AxialHorizontalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    app.ahcoordinate=round(evt.CurrentPosition(1,2));
                    app.sagittalVertical.Position=[app.ahcoordinate 0; app.ahcoordinate app.Axial];
                    imshow(rot90(permute(app.V(app.ahcoordinate,:,:),[2 3 1])),[],'Parent' ,app.CoronalAxes);
                    app.cvcoordinate=app.avcoordinate;
                    app.chcoordinate=app.shcoordinate;
                    app.coronalVertical=drawline('Parent',app.CoronalAxes,'Position',[app.cvcoordinate 0; app.cvcoordinate app.Axial],'LineWidth',0.25,'Color','b','InteractionsAllowed','translate');
                    app.coronalVertical.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                    app.coronalHorizontal=drawline('Parent',app.CoronalAxes,'Position',[0 app.chcoordinate; app.Sagittal app.chcoordinate],'LineWidth',0.25,'Color','g','InteractionsAllowed','translate');                
                    app.coronalHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                    addlistener(app.coronalVertical,'ROIMoved',@app.CoronalVerticalChanging);
                    addlistener(app.coronalHorizontal,'ROIMoved',@app.CoronalHorizontalChanging);                       
            end        
        end
        
        function SagittalVerticalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    app.svcoordinate=round(evt.CurrentPosition(1,1));
                    app.axialHorizontal.Position=[0 app.svcoordinate ; app.Sagittal app.svcoordinate];
                    imshow(rot90(permute(app.V(app.svcoordinate,:,:),[2 3 1])),[],'Parent' ,app.CoronalAxes);
                    app.cvcoordinate=app.avcoordinate;
                    app.chcoordinate=app.shcoordinate;
                    app.coronalVertical=drawline('Parent',app.CoronalAxes,'Position',[app.cvcoordinate 0; app.cvcoordinate app.Axial],'LineWidth',0.25,'Color','b','InteractionsAllowed','translate');
                    app.coronalVertical.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                    app.coronalHorizontal=drawline('Parent',app.CoronalAxes,'Position',[0 app.chcoordinate; app.Sagittal app.chcoordinate],'LineWidth',0.25,'Color','g','InteractionsAllowed','translate');                
                    app.coronalHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                    addlistener(app.coronalVertical,'ROIMoved',@app.CoronalVerticalChanging);
                    addlistener(app.coronalHorizontal,'ROIMoved',@app.CoronalHorizontalChanging);                     
            end
        end
        
        function SagittalHorizontalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    app.shcoordinate=round(evt.CurrentPosition(1,2));
                    app.coronalHorizontal.Position=[0 app.shcoordinate ; app.Sagittal app.shcoordinate];
                    imshow(app.V(:,:,(app.Axial-app.shcoordinate-1)),[],'Parent' ,app.AxialAxes);
                    app.avcoordinate=app.cvcoordinate;
                    app.ahcoordinate=app.svcoordinate;
                    app.axialVertical=drawline('Parent',app.AxialAxes,'Position',[app.avcoordinate 0; app.avcoordinate app.Coronal],'LineWidth',0.25,'Color','b','InteractionsAllowed','translate');
                    app.axialVertical.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    app.axialHorizontal=drawline('Parent',app.AxialAxes,'Position',[0 app.ahcoordinate; app.Sagittal app.ahcoordinate],'LineWidth',0.25,'Color','r','InteractionsAllowed','translate');
                    app.axialHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    app.obliqueLine=drawline('Parent',app.AxialAxes,'Position',[app.x1 app.y1; app.x2 app.y2],'LineWidth',0.25,'Color','w');
                    app.obliqueLine.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    addlistener(app.axialVertical,'ROIMoved',@app.AxialVerticalChanging);
                    addlistener(app.axialHorizontal,'ROIMoved',@app.AxialHorizontalChanging);
                    
                    addlistener(app.obliqueLine,'ROIMoved',@app.ObliqueChanging);
            end            
        end
        
        function CoronalVerticalChanging(app,src,evt)
            evname = evt.EventName;
            switch(evname)
                case{'ROIMoved'}
                    app.cvcoordinate=round(evt.CurrentPosition(1,1));
                    app.axialVertical.Position=[app.cvcoordinate 0;app.cvcoordinate app.Coronal ];
                    imshow(rot90(permute(app.V(:,app.cvcoordinate,:),[1 3 2])),[],'Parent' ,app.SagittalAxes);
                    app.svcoordinate=app.ahcoordinate;
                    app.shcoordinate=app.chcoordinate;
                    app.sagittalVertical=drawline('Parent',app.SagittalAxes,'Position',[app.svcoordinate 0; app.svcoordinate app.Axial],'LineWidth',0.25,'Color','r','InteractionsAllowed','translate');
                    app.sagittalVertical.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                    app.sagittalHorizontal=drawline('Parent',app.SagittalAxes,'Position',[0 app.shcoordinate; app.Coronal app.shcoordinate],'LineWidth',0.25,'Color','g','InteractionsAllowed','translate');
                    app.sagittalHorizontal.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                    addlistener(app.sagittalVertical,'ROIMoved',@app.SagittalVerticalChanging);
                    addlistener(app.sagittalHorizontal,'ROIMoved',@app.SagittalHorizontalChanging);  
            end              
        end
        
        function CoronalHorizontalChanging(app,src,evt)
                    app.chcoordinate=round(evt.CurrentPosition(1,2));
                    app.sagittalHorizontal.Position=[0 app.chcoordinate ; app.Coronal app.chcoordinate];
                    imshow(app.V(:,:,(app.Axial-app.chcoordinate-1)),[],'Parent' ,app.AxialAxes);
                    app.avcoordinate=app.cvcoordinate;
                    app.ahcoordinate=app.svcoordinate;
                    app.axialVertical=drawline('Parent',app.AxialAxes,'Position',[app.avcoordinate 0; app.avcoordinate app.Coronal],'LineWidth',0.25,'Color','b','InteractionsAllowed','translate');
                    app.axialVertical.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    app.axialHorizontal=drawline('Parent',app.AxialAxes,'Position',[0 app.ahcoordinate; app.Sagittal app.ahcoordinate],'LineWidth',0.25,'Color','r','InteractionsAllowed','translate');
                    app.axialHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    app.obliqueLine=drawline('Parent',app.AxialAxes,'Position',[app.x1 app.y1; app.x2 app.y2],'LineWidth',0.25,'Color','w');
                    app.obliqueLine.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                    addlistener(app.obliqueLine,'ROIMoved',@app.ObliqueChanging);
                    addlistener(app.axialVertical,'ROIMoved',@app.AxialVerticalChanging);
                    addlistener(app.axialHorizontal,'ROIMoved',@app.AxialHorizontalChanging);
                    
        end
        
        function ObliqueChanging(app,src,evt)
            app.x1=app.obliqueLine.Position(1,1);
            app.y1=app.obliqueLine.Position(1,2);
            app.x2=app.obliqueLine.Position(2,1);
            app.y2=app.obliqueLine.Position(2,2);
            midpointX=(app.x1+app.x2)/2;
            midpointY=(app.y1+app.y2)/2;
            rise=app.y2-app.y1;
            run=app.x2-app.x1;
            app.angle = atand(rise/run);
            newrise=-run;
            newrun=rise;
            point=[midpointX midpointY 100];
            normal = [newrun newrise 0];    
            app.B = obliqueslice(app.V,point,normal,'OutputSize','Full');
            imshow(imrotate(app.B,(app.angle-180)),[],'Parent' ,app.ObliqueAxes);
            addlistener(app.obliqueLine,'ROIMoved',@app.ObliqueChanging);

            
%             d=pdist(app.points,'euclidean')
%             app.yo1=app.roioblique.Position(1,2);
%             app.xo2=app.roioblique.Position(2,1);
%             app.yo2=app.roioblique.Position(2,2);
%             
%             app.xa1=app.roiaxial.Position(1,1);
%             app.ya1=app.roiaxial.Position(1,2);
%             app.xa2=app.roiaxial.Position(2,1);
%             app.ya2=app.roiaxial.Position(2,2);            
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
       
            folder = uigetdir; 
%             [Filename, Pathname,indx] = uigetfile({'*.dcm'}, 'All Files',folder);
%             fullname=[Pathname,Filename];
%             DicomImgData=dicominfo(fullname);
%             DicomImgData.SamplesPerPixel
            
            try
                app.V = dicomreadVolume(folder);  
                app.V = squeeze(app.V);
                disableDefaultInteractivity(app.AxialAxes)
                disableDefaultInteractivity(app.SagittalAxes)
                disableDefaultInteractivity(app.CoronalAxes)
                disableDefaultInteractivity(app.ObliqueAxes)
                
                app.Axial=size(app.V, 3);
                app.Sagittal=size(app.V, 2);
                app.Coronal=size(app.V, 1);
                
                
                 app.avcoordinate=round(app.Sagittal/2);
                 app.ahcoordinate=round(app.Coronal/2);
                 app.svcoordinate=round(app.Coronal/2);
                 app.shcoordinate=round(app.Axial/2);
                 app.cvcoordinate=round(app.Sagittal/2);
                 app.chcoordinate=round(app.Axial/2);
                 
                app.AxialMidPoint=round(app.Axial/2);
                app.SagittalMidPoint=round(app.Sagittal/2);
                app.CoronalMidPoint=round(app.Coronal/2);
               
                
                
                
                
                imshow(app.V(:,:,app.AxialMidPoint),[],'Parent' ,app.AxialAxes);
               
                
                app.axialVertical=drawline('Parent',app.AxialAxes,'Position',[app.avcoordinate 0; app.avcoordinate app.Coronal],'LineWidth',0.25,'Color','b','InteractionsAllowed','translate');
                app.axialVertical.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                app.axialHorizontal=drawline('Parent',app.AxialAxes,'Position',[0 app.ahcoordinate; app.Sagittal app.ahcoordinate],'LineWidth',0.25,'Color','r','InteractionsAllowed','translate');
                app.axialHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                addlistener(app.axialVertical,'ROIMoved',@app.AxialVerticalChanging);
                addlistener(app.axialHorizontal,'ROIMoved',@app.AxialHorizontalChanging);
                
                
                imshow(rot90(permute(app.V(:,app.SagittalMidPoint,:),[1 3 2])),[],'Parent' ,app.SagittalAxes);
                app.sagittalVertical=drawline('Parent',app.SagittalAxes,'Position',[app.svcoordinate 0; app.svcoordinate app.Axial],'LineWidth',0.25,'Color','r','InteractionsAllowed','translate');
                app.sagittalVertical.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                app.sagittalHorizontal=drawline('Parent',app.SagittalAxes,'Position',[0 app.shcoordinate; app.Coronal app.shcoordinate],'LineWidth',0.25,'Color','g','InteractionsAllowed','translate');
                app.sagittalHorizontal.DrawingArea = [0,0,(app.Coronal),(app.Axial)];
                addlistener(app.sagittalVertical,'ROIMoved',@app.SagittalVerticalChanging);
                addlistener(app.sagittalHorizontal,'ROIMoved',@app.SagittalHorizontalChanging);                
                
                imshow(rot90(permute(app.V(app.CoronalMidPoint,:,:),[2 3 1])),[],'Parent' ,app.CoronalAxes);
                app.coronalVertical=drawline('Parent',app.CoronalAxes,'Position',[app.cvcoordinate 0; app.cvcoordinate app.Axial],'LineWidth',0.25,'Color','b','InteractionsAllowed','translate');
                app.coronalVertical.DrawingArea = [0,0,(app.Sagittal),(app.Axial)];
                app.coronalHorizontal=drawline('Parent',app.CoronalAxes,'Position',[0 app.chcoordinate; app.Sagittal app.chcoordinate],'LineWidth',0.25,'Color','g','InteractionsAllowed','translate');                
                app.coronalHorizontal.DrawingArea = [0,0,(app.Sagittal),(app.Axial)]; 
                addlistener(app.coronalVertical,'ROIMoved',@app.CoronalVerticalChanging);
                addlistener(app.coronalHorizontal,'ROIMoved',@app.CoronalHorizontalChanging);                
                
                
                
                app.x1=0;
                app.y1=0;
                app.x2=app.Sagittal;
                app.y2=app.Coronal;
                rise=app.y2-app.y1;
                run=app.x2-app.x1;
                app.angle = atand(rise/run);                
                app.obliqueLine=drawline('Parent',app.AxialAxes,'Position',[app.x1 app.y1; app.x2 app.y2],'LineWidth',0.25,'Color','w');
                app.obliqueLine.DrawingArea = [0,0,(app.Sagittal),(app.Coronal)];
                point=[app.SagittalMidPoint app.CoronalMidPoint 100];
                normal = [1 -1 0];    
                app.B = obliqueslice(app.V,point,normal);
                imshow(imrotate(app.B,(app.angle-180)),[],'Parent' ,app.ObliqueAxes);
                addlistener(app.obliqueLine,'ROIMoved',@app.ObliqueChanging);

                
                
                
            catch 
                warndlg('Select Dicom Folder.','Warning');
            end 
        end

        % Button pushed function: LineButton
        function LineButtonPushed(app, event)
            app.ValueEditField.Value=' ';
            app.MeasureLabel.Text = 'Length';
            app.unitLabel.Text = 'mm';
            imshow(imrotate(app.B,(app.angle-180)),[],'Parent' ,app.ObliqueAxes);
            
            lineROI=drawline(app.ObliqueAxes,'LineWidth',0.25);
            lineROI.InteractionsAllowed='none';
            
            xo1=lineROI.Position(1,1);
            yo1=lineROI.Position(1,2);
            xo2=lineROI.Position(2,1);
            yo2=lineROI.Position(2,2);
           
            length=sqrt((xo1-xo2)^2+(yo1-yo2)^2);
            app.ValueEditField.Value=num2str(length);
        end

        % Button pushed function: PolygonButton
        function PolygonButtonPushed(app, event)
            app.ValueEditField.Value=' ';
            app.MeasureLabel.Text = 'Area';
            app.unitLabel.Text = 'mm²';
            imshow(imrotate(app.B,(app.angle-180)),[],'Parent' ,app.ObliqueAxes);
            
            polygonROI=drawpolygon(app.ObliqueAxes,'LineWidth',0.25);
            polygonROI.InteractionsAllowed='none';
            
            polygonArea=uint32(area(polyshape(polygonROI.Position)));
            app.ValueEditField.Value=num2str(polygonArea);
        end

        % Button pushed function: EllipseButton
        function EllipseButtonPushed(app, event)
            app.ValueEditField.Value=' ';
            app.MeasureLabel.Text = 'Area';
            app.unitLabel.Text = 'mm²';
            imshow(imrotate(app.B,(app.angle-180)),[],'Parent' ,app.ObliqueAxes);
            
            ellipseROI=drawellipse(app.ObliqueAxes,'LineWidth',0.25);
            ellipseROI.InteractionsAllowed='none';
            
            ellipseArea=pi*ellipseROI.SemiAxes(1)*ellipseROI.SemiAxes(2);
            app.ValueEditField.Value=num2str(ellipseArea);
        end

        % Button pushed function: AngleButton
        function AngleButtonPushed(app, event)
            app.ValueEditField.Value=' ';
            app.MeasureLabel.Text = 'Angle';
            app.unitLabel.Text = 'degree';
            imshow(imrotate(app.B,(app.angle-180)),[],'Parent' ,app.ObliqueAxes);
            
            line1ROI=drawline(app.ObliqueAxes,'LineWidth',0.25);
            line1ROI.InteractionsAllowed='none';
            line2ROI=drawline(app.ObliqueAxes,'LineWidth',0.25);
            line2ROI.InteractionsAllowed='none';
            
            x11=line1ROI.Position(1,1);
            y11=line1ROI.Position(1,2);
            x12=line1ROI.Position(2,1);
            y12=line1ROI.Position(2,2);
            
            x21=line2ROI.Position(1,1);
            y21=line2ROI.Position(1,2);
            x22=line2ROI.Position(2,1);
            y22=line2ROI.Position(2,2);

            v1 = [x12,y12,0] - [x11,y11,0];
            v2 = [x22,y22,0] - [x21,y21,0];
            Angle=atan2d(norm(cross(v1, v2)), dot(v1, v2));
            app.ValueEditField.Value=num2str(Angle);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create DicomViewer and hide until all components are created
            app.DicomViewer = uifigure('Visible', 'off');
            app.DicomViewer.Color = [0.149 0.149 0.149];
            app.DicomViewer.Position = [100 100 785 564];
            app.DicomViewer.Name = 'MATLAB App';
            app.DicomViewer.Scrollable = 'on';

            % Create BrowseButton
            app.BrowseButton = uibutton(app.DicomViewer, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.FontName = 'Yu Gothic Medium';
            app.BrowseButton.FontSize = 16;
            app.BrowseButton.Position = [34 506 85 34];
            app.BrowseButton.Text = 'Browse';

            % Create SagittalSlidesLabel
            app.SagittalSlidesLabel = uilabel(app.DicomViewer);
            app.SagittalSlidesLabel.FontName = 'Yu Gothic UI Light';
            app.SagittalSlidesLabel.FontSize = 16;
            app.SagittalSlidesLabel.FontWeight = 'bold';
            app.SagittalSlidesLabel.FontColor = [1 1 1];
            app.SagittalSlidesLabel.Position = [34 73 128 32];
            app.SagittalSlidesLabel.Text = 'Sagittal Slides';

            % Create ObliqueSlidesLabel
            app.ObliqueSlidesLabel = uilabel(app.DicomViewer);
            app.ObliqueSlidesLabel.FontName = 'Yu Gothic UI Light';
            app.ObliqueSlidesLabel.FontSize = 16;
            app.ObliqueSlidesLabel.FontWeight = 'bold';
            app.ObliqueSlidesLabel.FontColor = [1 1 1];
            app.ObliqueSlidesLabel.Position = [416 76 101 24];
            app.ObliqueSlidesLabel.Text = 'Oblique Slides';

            % Create AxialSlidesLabel
            app.AxialSlidesLabel = uilabel(app.DicomViewer);
            app.AxialSlidesLabel.FontName = 'Yu Gothic UI Light';
            app.AxialSlidesLabel.FontSize = 16;
            app.AxialSlidesLabel.FontWeight = 'bold';
            app.AxialSlidesLabel.FontColor = [1 1 1];
            app.AxialSlidesLabel.Position = [37 293 105 32];
            app.AxialSlidesLabel.Text = 'Axial Slides';

            % Create CoronalSlidesLabel
            app.CoronalSlidesLabel = uilabel(app.DicomViewer);
            app.CoronalSlidesLabel.FontName = 'Yu Gothic UI Light';
            app.CoronalSlidesLabel.FontSize = 16;
            app.CoronalSlidesLabel.FontWeight = 'bold';
            app.CoronalSlidesLabel.FontColor = [1 1 1];
            app.CoronalSlidesLabel.Position = [416 297 100 24];
            app.CoronalSlidesLabel.Text = 'Coronal Slides';

            % Create PolygonButton
            app.PolygonButton = uibutton(app.DicomViewer, 'push');
            app.PolygonButton.ButtonPushedFcn = createCallbackFcn(app, @PolygonButtonPushed, true);
            app.PolygonButton.BackgroundColor = [0.8196 0.8392 0.851];
            app.PolygonButton.FontName = 'Yu Gothic';
            app.PolygonButton.FontSize = 14;
            app.PolygonButton.Position = [494 21 69 30];
            app.PolygonButton.Text = 'Polygon';

            % Create LineButton
            app.LineButton = uibutton(app.DicomViewer, 'push');
            app.LineButton.ButtonPushedFcn = createCallbackFcn(app, @LineButtonPushed, true);
            app.LineButton.BackgroundColor = [0.8196 0.8392 0.851];
            app.LineButton.FontName = 'Yu Gothic';
            app.LineButton.FontSize = 14;
            app.LineButton.Position = [409 21 69 30];
            app.LineButton.Text = 'Line';

            % Create EllipseButton
            app.EllipseButton = uibutton(app.DicomViewer, 'push');
            app.EllipseButton.ButtonPushedFcn = createCallbackFcn(app, @EllipseButtonPushed, true);
            app.EllipseButton.BackgroundColor = [0.8196 0.8392 0.851];
            app.EllipseButton.FontName = 'Yu Gothic';
            app.EllipseButton.FontSize = 14;
            app.EllipseButton.Position = [660 21 69 30];
            app.EllipseButton.Text = 'Ellipse';

            % Create AngleButton
            app.AngleButton = uibutton(app.DicomViewer, 'push');
            app.AngleButton.ButtonPushedFcn = createCallbackFcn(app, @AngleButtonPushed, true);
            app.AngleButton.BackgroundColor = [0.8196 0.8392 0.851];
            app.AngleButton.FontName = 'Yu Gothic';
            app.AngleButton.FontSize = 14;
            app.AngleButton.Position = [578 21 69 30];
            app.AngleButton.Text = 'Angle';

            % Create MeasureLabel
            app.MeasureLabel = uilabel(app.DicomViewer);
            app.MeasureLabel.FontName = 'Yu Gothic UI Light';
            app.MeasureLabel.FontSize = 13;
            app.MeasureLabel.FontWeight = 'bold';
            app.MeasureLabel.FontColor = [1 1 1];
            app.MeasureLabel.Position = [549 73 43 22];
            app.MeasureLabel.Text = 'Length';

            % Create ValueEditField
            app.ValueEditField = uieditfield(app.DicomViewer, 'text');
            app.ValueEditField.Position = [593 73 77 19];

            % Create unitLabel
            app.unitLabel = uilabel(app.DicomViewer);
            app.unitLabel.FontName = 'Yu Gothic UI Light';
            app.unitLabel.FontSize = 13;
            app.unitLabel.FontWeight = 'bold';
            app.unitLabel.FontColor = [1 1 1];
            app.unitLabel.Position = [678 73 64 22];
            app.unitLabel.Text = 'mm';

            % Create AxialAxes
            app.AxialAxes = uiaxes(app.DicomViewer);
            zlabel(app.AxialAxes, 'Z')
            app.AxialAxes.Toolbar.Visible = 'off';
            app.AxialAxes.PlotBoxAspectRatio = [2.29468599033816 1 1];
            app.AxialAxes.XColor = [1 1 1];
            app.AxialAxes.XTick = [];
            app.AxialAxes.YColor = [1 1 1];
            app.AxialAxes.YTick = [];
            app.AxialAxes.Position = [18 319 341 177];

            % Create CoronalAxes
            app.CoronalAxes = uiaxes(app.DicomViewer);
            zlabel(app.CoronalAxes, 'Z')
            app.CoronalAxes.PlotBoxAspectRatio = [2.31707317073171 1 1];
            app.CoronalAxes.XColor = [1 1 1];
            app.CoronalAxes.XTick = [];
            app.CoronalAxes.YColor = [1 1 1];
            app.CoronalAxes.YTick = [];
            app.CoronalAxes.Position = [392 319 341 176];

            % Create SagittalAxes
            app.SagittalAxes = uiaxes(app.DicomViewer);
            zlabel(app.SagittalAxes, 'Z')
            app.SagittalAxes.PlotBoxAspectRatio = [2.28985507246377 1 1];
            app.SagittalAxes.XColor = [1 1 1];
            app.SagittalAxes.XTick = [];
            app.SagittalAxes.YColor = [1 1 1];
            app.SagittalAxes.YTick = [];
            app.SagittalAxes.Position = [17 99 341 177];

            % Create ObliqueAxes
            app.ObliqueAxes = uiaxes(app.DicomViewer);
            zlabel(app.ObliqueAxes, 'Z')
            app.ObliqueAxes.PlotBoxAspectRatio = [2.30097087378641 1 1];
            app.ObliqueAxes.XColor = [1 1 1];
            app.ObliqueAxes.XTick = [];
            app.ObliqueAxes.YColor = [1 1 1];
            app.ObliqueAxes.YTick = [];
            app.ObliqueAxes.Position = [391 100 341 176];

            % Show the figure after all components are created
            app.DicomViewer.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = BonusTask_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DicomViewer)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DicomViewer)
        end
    end
end