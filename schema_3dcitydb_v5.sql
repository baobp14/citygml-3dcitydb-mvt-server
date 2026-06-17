--
-- PostgreSQL database dump
--

\restrict 8DTzr2Gg4Mdif6k748mUo5OvMvsaavq0BwFGTJoaiqeM60BAjciv1jINK15ekEo

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg110+1)
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citydb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA citydb;


ALTER SCHEMA citydb OWNER TO postgres;

--
-- Name: address_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.address_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.address_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: address; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.address (
    id bigint DEFAULT nextval('citydb.address_seq'::regclass) NOT NULL,
    objectid text,
    identifier text,
    identifier_codespace text,
    street text,
    house_number text,
    po_box text,
    zip_code text,
    city text,
    state text,
    country text,
    free_text jsonb,
    multi_point public.geometry(MultiPointZ),
    content text,
    content_mime_type text
);


ALTER TABLE citydb.address OWNER TO postgres;

--
-- Name: ade_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.ade_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER SEQUENCE citydb.ade_seq OWNER TO postgres;

--
-- Name: ade; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.ade (
    id integer DEFAULT nextval('citydb.ade_seq'::regclass) NOT NULL,
    name text NOT NULL,
    description text,
    version text
);


ALTER TABLE citydb.ade OWNER TO postgres;

--
-- Name: appear_to_surface_data_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.appear_to_surface_data_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.appear_to_surface_data_seq OWNER TO postgres;

--
-- Name: appear_to_surface_data; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.appear_to_surface_data (
    id bigint DEFAULT nextval('citydb.appear_to_surface_data_seq'::regclass) NOT NULL,
    appearance_id bigint NOT NULL,
    surface_data_id bigint
);


ALTER TABLE citydb.appear_to_surface_data OWNER TO postgres;

--
-- Name: appearance_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.appearance_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.appearance_seq OWNER TO postgres;

--
-- Name: appearance; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.appearance (
    id bigint DEFAULT nextval('citydb.appearance_seq'::regclass) NOT NULL,
    objectid text,
    identifier text,
    identifier_codespace text,
    theme text,
    is_global integer,
    feature_id bigint,
    implicit_geometry_id bigint
);


ALTER TABLE citydb.appearance OWNER TO postgres;

--
-- Name: codelist_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.codelist_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.codelist_seq OWNER TO postgres;

--
-- Name: codelist; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.codelist (
    id bigint DEFAULT nextval('citydb.codelist_seq'::regclass) NOT NULL,
    codelist_type text,
    url text,
    mime_type text
);


ALTER TABLE citydb.codelist OWNER TO postgres;

--
-- Name: codelist_entry_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.codelist_entry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.codelist_entry_seq OWNER TO postgres;

--
-- Name: codelist_entry; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.codelist_entry (
    id bigint DEFAULT nextval('citydb.codelist_entry_seq'::regclass) NOT NULL,
    codelist_id bigint NOT NULL,
    code text,
    definition text
);


ALTER TABLE citydb.codelist_entry OWNER TO postgres;

--
-- Name: database_srs; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.database_srs (
    srid integer NOT NULL,
    srs_name text
);


ALTER TABLE citydb.database_srs OWNER TO postgres;

--
-- Name: datatype; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.datatype (
    id integer NOT NULL,
    supertype_id integer,
    typename text,
    is_abstract integer,
    ade_id integer,
    namespace_id integer,
    schema jsonb
);


ALTER TABLE citydb.datatype OWNER TO postgres;

--
-- Name: feature_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.feature_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.feature_seq OWNER TO postgres;

--
-- Name: feature; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.feature (
    id bigint DEFAULT nextval('citydb.feature_seq'::regclass) NOT NULL,
    objectclass_id integer NOT NULL,
    objectid text,
    identifier text,
    identifier_codespace text,
    envelope public.geometry(GeometryZ),
    last_modification_date timestamp with time zone,
    updating_person text,
    reason_for_update text,
    lineage text,
    creation_date timestamp with time zone,
    termination_date timestamp with time zone,
    valid_from timestamp with time zone,
    valid_to timestamp with time zone
);


ALTER TABLE citydb.feature OWNER TO postgres;

--
-- Name: geometry_data_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.geometry_data_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.geometry_data_seq OWNER TO postgres;

--
-- Name: geometry_data; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.geometry_data (
    id bigint DEFAULT nextval('citydb.geometry_data_seq'::regclass) NOT NULL,
    geometry public.geometry(GeometryZ),
    implicit_geometry public.geometry(GeometryZ),
    geometry_properties jsonb,
    feature_id bigint
);


ALTER TABLE citydb.geometry_data OWNER TO postgres;

--
-- Name: implicit_geometry_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.implicit_geometry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.implicit_geometry_seq OWNER TO postgres;

--
-- Name: implicit_geometry; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.implicit_geometry (
    id bigint DEFAULT nextval('citydb.implicit_geometry_seq'::regclass) NOT NULL,
    objectid text,
    mime_type text,
    mime_type_codespace text,
    reference_to_library text,
    library_object bytea,
    relative_geometry_id bigint
);


ALTER TABLE citydb.implicit_geometry OWNER TO postgres;

--
-- Name: namespace; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.namespace (
    id integer NOT NULL,
    alias text,
    namespace text,
    ade_id integer
);


ALTER TABLE citydb.namespace OWNER TO postgres;

--
-- Name: objectclass; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.objectclass (
    id integer NOT NULL,
    superclass_id integer,
    classname text,
    is_abstract integer,
    is_toplevel integer,
    ade_id integer,
    namespace_id integer,
    schema jsonb
);


ALTER TABLE citydb.objectclass OWNER TO postgres;

--
-- Name: property_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.property_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.property_seq OWNER TO postgres;

--
-- Name: property; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.property (
    id bigint DEFAULT nextval('citydb.property_seq'::regclass) NOT NULL,
    feature_id bigint,
    parent_id bigint,
    datatype_id integer NOT NULL,
    namespace_id integer,
    name text,
    val_int bigint,
    val_double double precision,
    val_string text,
    val_timestamp timestamp with time zone,
    val_uri text,
    val_codespace text,
    val_uom text,
    val_array jsonb,
    val_lod text,
    val_geometry_id bigint,
    val_implicitgeom_id bigint,
    val_implicitgeom_refpoint public.geometry(PointZ),
    val_appearance_id bigint,
    val_address_id bigint,
    val_feature_id bigint,
    val_relation_type integer,
    val_content text,
    val_content_mime_type text
);


ALTER TABLE citydb.property OWNER TO postgres;

--
-- Name: surface_data_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.surface_data_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.surface_data_seq OWNER TO postgres;

--
-- Name: surface_data; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.surface_data (
    id bigint DEFAULT nextval('citydb.surface_data_seq'::regclass) NOT NULL,
    objectid text,
    identifier text,
    identifier_codespace text,
    is_front integer,
    objectclass_id integer NOT NULL,
    x3d_shininess double precision,
    x3d_transparency double precision,
    x3d_ambient_intensity double precision,
    x3d_specular_color text,
    x3d_diffuse_color text,
    x3d_emissive_color text,
    x3d_is_smooth integer,
    tex_image_id bigint,
    tex_texture_type text,
    tex_wrap_mode text,
    tex_border_color text,
    gt_orientation jsonb,
    gt_reference_point public.geometry(Point)
);


ALTER TABLE citydb.surface_data OWNER TO postgres;

--
-- Name: surface_data_mapping; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.surface_data_mapping (
    surface_data_id bigint NOT NULL,
    geometry_data_id bigint NOT NULL,
    material_mapping jsonb,
    texture_mapping jsonb,
    world_to_texture_mapping jsonb,
    georeferenced_texture_mapping jsonb
);


ALTER TABLE citydb.surface_data_mapping OWNER TO postgres;

--
-- Name: tex_image_seq; Type: SEQUENCE; Schema: citydb; Owner: postgres
--

CREATE SEQUENCE citydb.tex_image_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE citydb.tex_image_seq OWNER TO postgres;

--
-- Name: tex_image; Type: TABLE; Schema: citydb; Owner: postgres
--

CREATE TABLE citydb.tex_image (
    id bigint DEFAULT nextval('citydb.tex_image_seq'::regclass) NOT NULL,
    image_uri text,
    image_data bytea,
    mime_type text,
    mime_type_codespace text
);


ALTER TABLE citydb.tex_image OWNER TO postgres;

--
-- Name: address address_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.address
    ADD CONSTRAINT address_pk PRIMARY KEY (id);


--
-- Name: ade ade_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.ade
    ADD CONSTRAINT ade_pk PRIMARY KEY (id);


--
-- Name: appear_to_surface_data appear_to_surface_data_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.appear_to_surface_data
    ADD CONSTRAINT appear_to_surface_data_pk PRIMARY KEY (id);


--
-- Name: appearance appearance_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.appearance
    ADD CONSTRAINT appearance_pk PRIMARY KEY (id);


--
-- Name: codelist_entry codelist_entry_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.codelist_entry
    ADD CONSTRAINT codelist_entry_pk PRIMARY KEY (id);


--
-- Name: codelist codelist_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.codelist
    ADD CONSTRAINT codelist_pk PRIMARY KEY (id);


--
-- Name: database_srs database_srs_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.database_srs
    ADD CONSTRAINT database_srs_pk PRIMARY KEY (srid);


--
-- Name: datatype datatype_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.datatype
    ADD CONSTRAINT datatype_pk PRIMARY KEY (id);


--
-- Name: feature feature_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.feature
    ADD CONSTRAINT feature_pk PRIMARY KEY (id);


--
-- Name: geometry_data geometry_data_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.geometry_data
    ADD CONSTRAINT geometry_data_pk PRIMARY KEY (id);


--
-- Name: implicit_geometry implicit_geometry_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.implicit_geometry
    ADD CONSTRAINT implicit_geometry_pk PRIMARY KEY (id);


--
-- Name: namespace namespace_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.namespace
    ADD CONSTRAINT namespace_pk PRIMARY KEY (id);


--
-- Name: objectclass objectclass_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.objectclass
    ADD CONSTRAINT objectclass_pk PRIMARY KEY (id);


--
-- Name: property property_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.property
    ADD CONSTRAINT property_pk PRIMARY KEY (id);


--
-- Name: surface_data_mapping surface_data_mapping_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.surface_data_mapping
    ADD CONSTRAINT surface_data_mapping_pk PRIMARY KEY (geometry_data_id, surface_data_id);


--
-- Name: surface_data surface_data_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.surface_data
    ADD CONSTRAINT surface_data_pk PRIMARY KEY (id);


--
-- Name: tex_image tex_image_pk; Type: CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.tex_image
    ADD CONSTRAINT tex_image_pk PRIMARY KEY (id);


--
-- Name: appear_to_surface_data_fkx1; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX appear_to_surface_data_fkx1 ON citydb.appear_to_surface_data USING btree (surface_data_id);


--
-- Name: appear_to_surface_data_fkx2; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX appear_to_surface_data_fkx2 ON citydb.appear_to_surface_data USING btree (appearance_id);


--
-- Name: appearance_feature_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX appearance_feature_fkx ON citydb.appearance USING btree (feature_id);


--
-- Name: appearance_implicit_geom_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX appearance_implicit_geom_fkx ON citydb.appearance USING btree (implicit_geometry_id);


--
-- Name: appearance_theme_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX appearance_theme_inx ON citydb.appearance USING btree (theme);


--
-- Name: codelist_codelist_type_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX codelist_codelist_type_inx ON citydb.codelist USING btree (codelist_type);


--
-- Name: codelist_entry_codelist_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX codelist_entry_codelist_fkx ON citydb.codelist_entry USING btree (codelist_id);


--
-- Name: datatype_supertype_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX datatype_supertype_fkx ON citydb.datatype USING btree (supertype_id);


--
-- Name: feature_creation_date_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX feature_creation_date_inx ON citydb.feature USING btree (creation_date);


--
-- Name: feature_identifier_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX feature_identifier_inx ON citydb.feature USING btree (identifier, identifier_codespace);


--
-- Name: feature_objectclass_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX feature_objectclass_inx ON citydb.feature USING btree (objectclass_id);


--
-- Name: feature_objectid_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX feature_objectid_inx ON citydb.feature USING btree (objectid);


--
-- Name: feature_termination_date_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX feature_termination_date_inx ON citydb.feature USING btree (termination_date);


--
-- Name: feature_valid_from_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX feature_valid_from_inx ON citydb.feature USING btree (valid_from);


--
-- Name: feature_valid_to_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX feature_valid_to_inx ON citydb.feature USING btree (valid_to);


--
-- Name: geometry_data_feature_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX geometry_data_feature_fkx ON citydb.geometry_data USING btree (feature_id);


--
-- Name: implicit_geometry_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX implicit_geometry_fkx ON citydb.implicit_geometry USING btree (relative_geometry_id);


--
-- Name: implicit_geometry_objectid_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX implicit_geometry_objectid_inx ON citydb.implicit_geometry USING btree (objectid);


--
-- Name: objectclass_superclass_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX objectclass_superclass_fkx ON citydb.objectclass USING btree (superclass_id);


--
-- Name: property_feature_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_feature_fkx ON citydb.property USING btree (feature_id);


--
-- Name: property_name_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_name_inx ON citydb.property USING btree (name);


--
-- Name: property_namespace_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_namespace_inx ON citydb.property USING btree (namespace_id);


--
-- Name: property_parent_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_parent_fkx ON citydb.property USING btree (parent_id);


--
-- Name: property_val_address_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_address_fkx ON citydb.property USING btree (val_address_id);


--
-- Name: property_val_appearance_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_appearance_fkx ON citydb.property USING btree (val_appearance_id);


--
-- Name: property_val_date_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_date_inx ON citydb.property USING btree (val_timestamp) WHERE (val_timestamp IS NOT NULL);


--
-- Name: property_val_double_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_double_inx ON citydb.property USING btree (val_double) WHERE (val_double IS NOT NULL);


--
-- Name: property_val_feature_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_feature_fkx ON citydb.property USING btree (val_feature_id);


--
-- Name: property_val_geometry_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_geometry_fkx ON citydb.property USING btree (val_geometry_id);


--
-- Name: property_val_implicitgeom_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_implicitgeom_fkx ON citydb.property USING btree (val_implicitgeom_id);


--
-- Name: property_val_int_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_int_inx ON citydb.property USING btree (val_int) WHERE (val_int IS NOT NULL);


--
-- Name: property_val_lod_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_lod_inx ON citydb.property USING btree (val_lod);


--
-- Name: property_val_relation_type_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_relation_type_inx ON citydb.property USING btree (val_relation_type);


--
-- Name: property_val_string_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_string_inx ON citydb.property USING btree (val_string) WHERE (val_string IS NOT NULL);


--
-- Name: property_val_uom_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_uom_inx ON citydb.property USING btree (val_uom) WHERE (val_uom IS NOT NULL);


--
-- Name: property_val_uri_inx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX property_val_uri_inx ON citydb.property USING btree (val_uri) WHERE (val_uri IS NOT NULL);


--
-- Name: surface_data_mapping_fkx1; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX surface_data_mapping_fkx1 ON citydb.surface_data_mapping USING btree (geometry_data_id);


--
-- Name: surface_data_mapping_fkx2; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX surface_data_mapping_fkx2 ON citydb.surface_data_mapping USING btree (surface_data_id);


--
-- Name: surface_data_objclass_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX surface_data_objclass_fkx ON citydb.surface_data USING btree (objectclass_id);


--
-- Name: surface_data_tex_image_fkx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX surface_data_tex_image_fkx ON citydb.surface_data USING btree (tex_image_id);


--
-- Name: appear_to_surface_data appear_to_surface_data_fk1; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.appear_to_surface_data
    ADD CONSTRAINT appear_to_surface_data_fk1 FOREIGN KEY (surface_data_id) REFERENCES citydb.surface_data(id) ON DELETE CASCADE;


--
-- Name: appear_to_surface_data appear_to_surface_data_fk2; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.appear_to_surface_data
    ADD CONSTRAINT appear_to_surface_data_fk2 FOREIGN KEY (appearance_id) REFERENCES citydb.appearance(id) ON DELETE CASCADE;


--
-- Name: appearance appearance_feature_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.appearance
    ADD CONSTRAINT appearance_feature_fk FOREIGN KEY (feature_id) REFERENCES citydb.feature(id) ON DELETE SET NULL;


--
-- Name: appearance appearance_implicit_geom_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.appearance
    ADD CONSTRAINT appearance_implicit_geom_fk FOREIGN KEY (implicit_geometry_id) REFERENCES citydb.implicit_geometry(id) ON DELETE CASCADE;


--
-- Name: codelist_entry codelist_entry_codelist_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.codelist_entry
    ADD CONSTRAINT codelist_entry_codelist_fk FOREIGN KEY (codelist_id) REFERENCES citydb.codelist(id) ON DELETE CASCADE;


--
-- Name: datatype datatype_ade_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.datatype
    ADD CONSTRAINT datatype_ade_fk FOREIGN KEY (ade_id) REFERENCES citydb.ade(id) ON DELETE CASCADE;


--
-- Name: datatype datatype_namespace_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.datatype
    ADD CONSTRAINT datatype_namespace_fk FOREIGN KEY (namespace_id) REFERENCES citydb.namespace(id) ON DELETE CASCADE;


--
-- Name: datatype datatype_supertype_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.datatype
    ADD CONSTRAINT datatype_supertype_fk FOREIGN KEY (supertype_id) REFERENCES citydb.datatype(id) ON DELETE CASCADE;


--
-- Name: namespace fk_namespace_ade; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.namespace
    ADD CONSTRAINT fk_namespace_ade FOREIGN KEY (ade_id) REFERENCES citydb.ade(id) ON DELETE CASCADE;


--
-- Name: geometry_data geometry_data_feature_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.geometry_data
    ADD CONSTRAINT geometry_data_feature_fk FOREIGN KEY (feature_id) REFERENCES citydb.feature(id) ON DELETE SET NULL;


--
-- Name: implicit_geometry implicit_geometry_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.implicit_geometry
    ADD CONSTRAINT implicit_geometry_fk FOREIGN KEY (relative_geometry_id) REFERENCES citydb.geometry_data(id) ON DELETE CASCADE;


--
-- Name: objectclass objectclass_ade_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.objectclass
    ADD CONSTRAINT objectclass_ade_fk FOREIGN KEY (ade_id) REFERENCES citydb.ade(id) ON DELETE CASCADE;


--
-- Name: objectclass objectclass_namespace_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.objectclass
    ADD CONSTRAINT objectclass_namespace_fk FOREIGN KEY (namespace_id) REFERENCES citydb.namespace(id) ON DELETE CASCADE;


--
-- Name: objectclass objectclass_superclass_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.objectclass
    ADD CONSTRAINT objectclass_superclass_fk FOREIGN KEY (superclass_id) REFERENCES citydb.objectclass(id) ON DELETE CASCADE;


--
-- Name: property property_appearance_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.property
    ADD CONSTRAINT property_appearance_fk FOREIGN KEY (val_appearance_id) REFERENCES citydb.appearance(id) ON DELETE CASCADE;


--
-- Name: property property_feature_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.property
    ADD CONSTRAINT property_feature_fk FOREIGN KEY (feature_id) REFERENCES citydb.feature(id);


--
-- Name: property property_parent_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.property
    ADD CONSTRAINT property_parent_fk FOREIGN KEY (parent_id) REFERENCES citydb.property(id) ON DELETE SET NULL;


--
-- Name: property property_val_address_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.property
    ADD CONSTRAINT property_val_address_fk FOREIGN KEY (val_address_id) REFERENCES citydb.address(id) ON DELETE CASCADE;


--
-- Name: property property_val_feature_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.property
    ADD CONSTRAINT property_val_feature_fk FOREIGN KEY (val_feature_id) REFERENCES citydb.feature(id) ON DELETE SET NULL;


--
-- Name: property property_val_geometry_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.property
    ADD CONSTRAINT property_val_geometry_fk FOREIGN KEY (val_geometry_id) REFERENCES citydb.geometry_data(id) ON DELETE CASCADE;


--
-- Name: property property_val_implicitgeom_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.property
    ADD CONSTRAINT property_val_implicitgeom_fk FOREIGN KEY (val_implicitgeom_id) REFERENCES citydb.implicit_geometry(id) ON DELETE CASCADE;


--
-- Name: surface_data_mapping surface_data_mapping_fk1; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.surface_data_mapping
    ADD CONSTRAINT surface_data_mapping_fk1 FOREIGN KEY (geometry_data_id) REFERENCES citydb.geometry_data(id) ON DELETE CASCADE;


--
-- Name: surface_data_mapping surface_data_mapping_fk2; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.surface_data_mapping
    ADD CONSTRAINT surface_data_mapping_fk2 FOREIGN KEY (surface_data_id) REFERENCES citydb.surface_data(id) ON DELETE CASCADE;


--
-- Name: surface_data surface_data_tex_image_fk; Type: FK CONSTRAINT; Schema: citydb; Owner: postgres
--

ALTER TABLE ONLY citydb.surface_data
    ADD CONSTRAINT surface_data_tex_image_fk FOREIGN KEY (tex_image_id) REFERENCES citydb.tex_image(id) ON DELETE SET NULL;


----
-- Name: geometry_data_spatial_idx; Type: INDEX; Schema: citydb; Owner: postgres
--

CREATE INDEX geometry_data_spatial_idx ON citydb.geometry_data USING gist (geometry);
CREATE INDEX geometry_data_impl_spatial_idx ON citydb.geometry_data USING gist (implicit_geometry);
-- PostgreSQL database dump complete
--

\unrestrict 8DTzr2Gg4Mdif6k748mUo5OvMvsaavq0BwFGTJoaiqeM60BAjciv1jINK15ekEo

