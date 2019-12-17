Include %DeepSee
Class IRISDemo.PivotAndDashboard Extends %DeepSee.UserLibrary.Container [ Not ProcedureBlock ]
{

/// Items Exported From Folder Manager.
XData Contents [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<items><dashboard xmlns="http://www.intersystems.com/deepsee/library" name="QualityAvailabilityKPI" folderName="IRISDemo" title="" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="2019-03-01T15:11:24.332Z" createdBy="_SYSTEM" category="" bookCover="" scheme="" worklistCount="0" snapTo="true" snapGrid="true" gridRows="10" gridCols="10" canResize="true" canModify="true" showTitleBar="true" titleBarOpacity="" titleBarColor="" selectedTitleBarOpacity="" selectedTitleBarColor="" titleBarTextColor="" selectedTitleBarTextColor="" titleBarFont="" companyName="" companyLogo="" companyStyle="" backgroundColor="white" backgroundImage="none" backgroundRepeat="no-repeat" backgroundSize="100% 100%" backgroundOpacity="1" widgetBorders="1px solid #F0F0F0" widgetBordersSwitch="edit" widgetBordersColor="#F0F0F0" widgetBordersStyle="solid" widgetBordersWidth="1" widgetBordersToggle="true">
  <widget name="KPI Chart" type="pivot" subtype="comboChart" subtypeClass="comboChart" title="" dataSource="IRISDemo/QualityAvailabiltyKPI.pivot" dataLink="" drillDownDataSource="" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="true" homeRowL="0" homeColL="0" colSpanL="4" rowSpanL="4" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
    <control name="" action="refresh" target="" targetProperty="[ProductionOrder].[H1].[ProductionOrder]" location="widget" type="auto" controlClass="" label="" title="" value="" text="" readOnly="false" valueList="" displayList="" activeWhen="">
      <valueRequired>false</valueRequired>
    </control>
    <control name="" action="applyFilter" target="" targetProperty="[ProductionOrder].[H1].[ProductionOrder]" location="widget" type="auto" controlClass="" label="ProductionOrder" title="" value="" text="" readOnly="false" valueList="" displayList="" activeWhen="">
      <valueRequired>false</valueRequired>
    </control>
    <control name="" action="applyFilter" target="" targetProperty="[ItemCode].[H1].[ItemCode]" location="widget" type="auto" controlClass="" label="ItemCode" title="" value="" text="" readOnly="false" valueList="" displayList="" activeWhen="">
      <valueRequired>false</valueRequired>
    </control>
    <property name="chartToggle">none</property>
    <property name="drillDown">1</property>
    <override name="comboChart">{legendVisible:'false',markersVisible:true,xAxis:{_type:'axis'},yAxisList:[{axisType:'percent',maxValue:1,minorGridLines:true,title:'Percentage',_type:'axis'}],seriesTypes:'bar,bar,line',_type:'comboChart'}</override>
  </widget>
</dashboard>
<pivot xmlns="http://www.intersystems.com/deepsee/library" name="QualityAvailabiltyKPI" folderName="IRISDemo" title="" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="2019-02-25T14:06:19.093Z" createdBy="_SYSTEM" category="" bookCover="" mdx="" cellWidth="120" columnHeaderStyle="" rowHeaderStyle="" cellStyle="" rowLabelSpan="true" columnLabelSpan="true" cellHeight="22" showEmptyRows="false" showEmptyColumns="false" cubeName="TIMESLICE" caption="" listing="" listingRows="" showStatus="true" pageSize="100" colorScale="" rowTotals="false" columnTotals="false" rowTotalAgg="sum" columnTotalAgg="sum" rowTotalSource="page" showZebra="false" showRowCaption="true" printTitle="" printSubtitle="" printSubtitleOn="" showUser="" printPageSize="" printOrientation="1" printMarginTop="" printMarginLeft="" printMarginRight="" printMarginBottom="" printLabelWidth="" printCellWidth="" autoExecute="true" previewMode="false" manualMode="false" userMDX="" chartMarginTop="" chartMarginLeft="" chartMarginRight="" chartMarginBottom="" maxRows="" borderLeftCell="" borderRightCell="" borderTopCell="" borderBottomCell="" borderLeftCol="" borderRightCol="" borderTopCol="" borderBottomCol="" borderLeftRow="" borderRightRow="" borderTopRow="" borderBottomRow="" fontFamilyCell="" fontSizeCell="" fontFamilyCol="" fontSizeCol="" fontFamilyRow="" fontSizeRow="" showFilters="" showListingFilters="" showDate="" listingFontSize="" showZebraStripes="" filterTableStyle="" filterTableCaptionStyle="" filterTableItemStyle="" nowDisplayFormat="" measureLocation="columns" hideMeasures="1" backgroundImage="" backgroundOpacity=".12">
  <rowAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </rowAxisOptions>
  <columnAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </columnAxisOptions>
  <rowLevel spec="[StartTime].[H1].[StartDate].Members" key="" value="" text="StartDate" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </rowLevel>
  <sqlRestriction></sqlRestriction>
  <measure spec="[MEASURES].[QUALITY]" key="" value="" text="Quality" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </measure>
  <measure spec="[MEASURES].[AVAILABILITY]" key="" value="" text="Availability" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </measure>
</pivot>
</items>
}

}

